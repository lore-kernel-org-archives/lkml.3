Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab3JJVXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:23:14 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:52944 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab3JJVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:23:12 -0400
MIME-Version: 1.0
Date: Thu, 10 Oct 2013 23:23:11 +0200
Message-ID: <CAG3eYYSNYHaKB8REe_M16tUGC3iNDjLsHES+KvTQXknnWZSGUg@mail.gmail.com>
Subject: PROBLEM: udf mount takes forever to fail + proposed solution
From: =?UTF-8?B?UMOpdGVyIEFuZHLDoXMgRmVsdsOpZ2k=?= <petschy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a11344474ea88ea04e8699bf7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11344474ea88ea04e8699bf7
Content-Type: text/plain; charset=UTF-8

Hello,

recently I made the mistake trying to mount an unformatted ssd
partition. The mount command 'hang', was unable to kill it. Top showed
the process is in the uninterruptible D state. However, iotop showed
slight activity, about 4M/s read from the disk that noone else used.
This was 100% reproducible. sync froze, too, if was given out after
the mount cmd. When trying to shut down the machine, it didn't stop,
just waited for something to happen.

I narrowed down the problem to the UDF filesystem driver. In
fs/udf/super.c, udf_check_vsd() reads the sectors in a for loop, with
the following exit conditions:
- NSR02 or NSR03 descriptor is found
- the read fails
- vsd->stdIdent[0] == 0

Browsed through the UDF 2.6 spec, ECMA 167 and 119. As I understand,
the descriptors should start at offset 32768, forming a contiguous
sequence. In ECMA 167 it is stated that the sequence is terminated by
an invalid descriptor: unrecorded, or blank (all zeros). However, this
presupposes that the filesystem is UDF.

Since the ssd partition was not formatted, it contained only 0xff
bytes, thus none of the exit conditions were met, and the function
read through the whole, in two passes. The runtime was pathetic, it
took the mount 350 minutes to fail. I have no clue why this was so
slow, reading through the partition with dd gives 482 secs for the
220G, ~450M/s. Setting the blocksize to 512 or 2048 didn't make much
of a difference.

I peppered the code with some messages to see what happens:
# time mount -t udf /dev/sdb3 /media/floppy
UDF-fs: check_vsd: sectorsize=2048
UDF-fs: check_vsd: sector offs=32768, s_blocksize=512, s_blocksize_bits=9
UDF-fs: read 107989660 sectors of total size 55290705920 bytes
UDF-fs: warning (device sdb3): udf_load_vrs: No VRS found
UDF-fs: Rescanning with blocksize 2048
UDF-fs: check_vsd: sectorsize=2048
UDF-fs: check_vsd: sector offs=32768, s_blocksize=2048, s_blocksize_bits=11
UDF-fs: read 107989660 sectors of total size 221162823680 bytes
UDF-fs: warning (device sdb3): udf_load_vrs: No VRS found
UDF-fs: warning (device sdb3): udf_fill_super: No partition found (1)
mount: wrong fs type, bad option, bad superblock on /dev/sdb3,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
real    352m4.740s
user    0m0.000s
sys     27m23.560s

Tried to mount other partitions, too, formatted to ext3, ext4, btrfs
and ntfs. The mount failed with those sooner, accidentally just
because there were some blocks near to the beginning with a zero byte
just at the right place.

Then I prepared an 'all 0xff' 4G image, and burnt it to a DVD. The
mount failed, but took only 25 minutes. 'Only', compared to the case
with the ssd. This truely doesn't reflect the throughput of the
devices, hopefully someone with more experience will have a clue.

The proposed solution changes the for() loop exit condition so that
not a zero byte but an invalid descriptor id is checked. Since all
current ids are 0-9A-Z, I think it's plausible to expect future ids
will have the same form. If not, the code could be changed later,
anyway.

Mounting the invalid ssd partition with the patch in debug mode looks like this:
# time mount -t udf /dev/sdb3 /media/floppy
UDF-fs: udf_is_vsd_id_valid: at offset 0x00008000 vsd.stdIdent[] = {
ff ff ff ff ff } : invalid
UDF-fs: warning (device sdb3): udf_load_vrs: No anchor found
UDF-fs: Rescanning with blocksize 2048
UDF-fs: udf_is_vsd_id_valid: at offset 0x00008000 vsd.stdIdent[] = {
ff ff ff ff ff } : invalid
UDF-fs: warning (device sdb3): udf_load_vrs: No anchor found
UDF-fs: warning (device sdb3): udf_fill_super: No partition found (1)
mount: wrong fs type, bad option, bad superblock on /dev/sdb3,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
real    0m0.009s
user    0m0.000s
sys     0m0.000s

And with a valid UDF fs:
# time mount -t udf /dev/sr1 /media/floppy
mount: block device /dev/sr1 is write-protected, mounting read-only
UDF-fs: udf_is_vsd_id_valid: at offset 0x00008000 vsd.stdIdent[] = {
43 44 30 30 31 } : valid (CD001)
UDF-fs: udf_is_vsd_id_valid: at offset 0x00008800 vsd.stdIdent[] = {
43 44 30 30 31 } : valid (CD001)
UDF-fs: udf_is_vsd_id_valid: at offset 0x00009000 vsd.stdIdent[] = {
42 45 41 30 31 } : valid (BEA01)
UDF-fs: udf_is_vsd_id_valid: at offset 0x00009800 vsd.stdIdent[] = {
4e 53 52 30 32 } : valid (NSR02)
UDF-fs: Partition marked readonly; forcing readonly mount
real    0m0.290s
user    0m0.000s
sys     0m0.000s

Please comment on the attached patch and merge it if acceptable. It
was made against 0bfd8ff (v3.9.4), but applied successfully to
v3.12-rc3, too.

Kind regards, Peter

--001a11344474ea88ea04e8699bf7
Content-Type: application/octet-stream; name="super.patch"
Content-Disposition: attachment; filename="super.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmmh77vh0

ZGlmZiAtLWdpdCBhL2ZzL3VkZi9zdXBlci5jIGIvZnMvdWRmL3N1cGVyLmMKaW5kZXggOWFjNDA1
Ny4uYjkzMDZmOCAxMDA2NDQKLS0tIGEvZnMvdWRmL3N1cGVyLmMKKysrIGIvZnMvdWRmL3N1cGVy
LmMKQEAgLTY2Nyw2ICs2NjcsNDAgQEAgb3V0X3VubG9jazoKIAlyZXR1cm4gZXJyb3I7CiB9CiAK
K3N0YXRpYyBpbnQgdWRmX2lzX3ZzZF9pZF92YWxpZChsb2ZmX3Qgb2ZmLCBjb25zdCBzdHJ1Y3Qg
dm9sU3RydWN0RGVzYyogdnNkKQoreworCS8qIFN1cHBvc2UgYWxsIHZhbGlkIGlkZW50aWZpZXJz
IGFyZSAwLTlBLVogKi8KKwlpbnQgdiA9IDE7CisJaW50IGk7CisJZm9yIChpID0gMDsgaSA8IHNp
emVvZih2c2QtPnN0ZElkZW50KTsgKytpKSB7CisJCWludCBjID0gdnNkLT5zdGRJZGVudFtpXTsK
KwkJLyogaXNhbG51bShjKSBnaXZlcyBmYWxzZSBwb3NpdGl2ZXMsIGVnIGZvciAweGZmICovCisJ
CWlmICgoYyA8ICcwJyB8fCBjID4gJzknKSAmJiAoYyA8ICdBJyB8fCBjID4gJ1onKSkgeworCQkJ
diA9IDA7CisJCQlicmVhazsKKwkJfQorCX0KKyNpZmRlZiBVREZGU19ERUJVRworCXsKKwkJY2hh
ciBoZXhbc2l6ZW9mKHZzZC0+c3RkSWRlbnQpICogMyArIDFdID0geyAwIH07CisJCWNoYXIgY2hy
W3NpemVvZih2c2QtPnN0ZElkZW50KSArIDEgXSA9IHsgMCB9OworCQljaGFyKiBocCA9IGhleDsK
KwkJY2hhciogaGUgPSBoZXggKyBzaXplb2YoaGV4KTsKKwkJY2hhciogY3AgPSBjaHI7CisJCWNo
YXIqIGNlID0gY2hyICsgc2l6ZW9mKGNocik7CisJCWZvciAoaSA9IDA7IGkgPCBzaXplb2YodnNk
LT5zdGRJZGVudCk7ICsraSkgeworCQkJc25wcmludGYoaHAsIGhlIC0gaHAsICIlMDJ4ICIsIHZz
ZC0+c3RkSWRlbnRbaV0pOworCQkJaHAgKz0gMzsKKwkJCXNucHJpbnRmKGNwLCBjZSAtIGNwLCAi
JWMiLCB2c2QtPnN0ZElkZW50W2ldKTsKKwkJCSsrY3A7CisJCX0KKwkJcHJfbm90aWNlKCIlczog
YXQgb2Zmc2V0IDB4JTA4bGx4IHZzZC5zdGRJZGVudFtdID0geyAlc30gOiAlcyVzJXMlc1xuIiwg
X19mdW5jX18sIG9mZiwgaGV4LAorCQkJICB2ID8gInZhbGlkIiA6ICJpbnZhbGlkIiwgdiA/ICIg
KCIgOiAiIiwgdiA/IGNociA6ICIiLCB2ID8gIikiIDogIiIpOworCX0KKyNlbmRpZgorCXJldHVy
biB2OworfQorCiAvKiBDaGVjayBWb2x1bWUgU3RydWN0dXJlIERlc2NyaXB0b3JzIChFQ01BIDE2
NyAyLzkuMSkgKi8KIC8qIFdlIGFsc28gY2hlY2sgYW55ICJDRC1ST00gVm9sdW1lIERlc2NyaXB0
b3IgU2V0IiAoRUNNQSAxNjcgMi84LjMuMSkgKi8KIHN0YXRpYyBsb2ZmX3QgdWRmX2NoZWNrX3Zz
ZChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQpAQCAtNzAxLDcgKzczNSw3IEBAIHN0YXRpYyBsb2Zm
X3QgdWRmX2NoZWNrX3ZzZChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogCQl2c2QgPSAoc3RydWN0
IHZvbFN0cnVjdERlc2MgKikoYmgtPmJfZGF0YSArCiAJCQkJCSAgICAgIChzZWN0b3IgJiAoc2It
PnNfYmxvY2tzaXplIC0gMSkpKTsKIAotCQlpZiAodnNkLT5zdGRJZGVudFswXSA9PSAwKSB7CisJ
CWlmICghdWRmX2lzX3ZzZF9pZF92YWxpZChzZWN0b3IsIHZzZCkpIHsKIAkJCWJyZWxzZShiaCk7
CiAJCQlicmVhazsKIAkJfSBlbHNlIGlmICghc3RybmNtcCh2c2QtPnN0ZElkZW50LCBWU0RfU1RE
X0lEX0NEMDAxLApAQCAtMTIzOSw2ICsxMjczLDkgQEAgc3RhdGljIGludCB1ZGZfbG9hZF9wYXJ0
ZGVzYyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBzZWN0b3JfdCBibG9jaykKIAkgKiBQSFlTSUNB
TCBwYXJ0aXRpb25zIGFyZSBhbHJlYWR5IHNldCB1cAogCSAqLwogCXR5cGUxX2lkeCA9IGk7Cisj
aWZkZWYgVURGRlNfREVCVUcKKwltYXAgPSBOVUxMOyAvKiBzdXByZXNzICdtYXliZSB1c2VkIHVu
aW5pdGlhbGl6ZWQnIHdhcm5pbmcgKi8KKyNlbmRpZgogCWZvciAoaSA9IDA7IGkgPCBzYmktPnNf
cGFydGl0aW9uczsgaSsrKSB7CiAJCW1hcCA9ICZzYmktPnNfcGFydG1hcHNbaV07CiAK
--001a11344474ea88ea04e8699bf7--
