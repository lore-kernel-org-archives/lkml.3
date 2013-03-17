Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3CQBCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 21:02:12 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:51616 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3CQBCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 21:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <5144BB15.3020002@gmail.com>
References: <20130307052854.GA23745@redhat.com>
	<20130307060230.GA31738@kroah.com>
	<20130307062626.GA25095@redhat.com>
	<51429D7A.30906@gmail.com>
	<5142ABD3.4040106@gmail.com>
	<CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com>
	<CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com>
	<51448AC9.7080105@gmail.com>
	<CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com>
	<CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com>
	<5144BB15.3020002@gmail.com>
Date: Sun, 17 Mar 2013 09:02:09 +0800
Message-ID: <CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com>
Subject: Re: use after free in sysfs_find_dirent
From: Ming Lei <tom.leiming@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b6dc6ceffb9da04d8146b03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6dc6ceffb9da04d8146b03
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Mar 17, 2013 at 2:33 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>
> I don't think it shows what we want it to show thought:
>
> [  327.416905] Pid: 10504, comm: trinity-child98 Tainted: G        W    3.9.0-rc2-next-20130315-sasha-00046-gecde602-dirty #301
> [  327.418815] Call Trace:
> [  327.419255]  [<ffffffff812f880e>] release_sysfs_dirent+0x4e/0x120
> [  327.420595]  [<ffffffff812f89d2>] sysfs_dir_pos+0x92/0x130
> [  327.421608]  [<ffffffff812f8b8d>] sysfs_readdir+0x11d/0x280
> [  327.422562]  [<ffffffff8128b070>] ? SyS_ioctl+0xa0/0xa0
> [  327.423441]  [<ffffffff8128b070>] ? SyS_ioctl+0xa0/0xa0
> [  327.424314]  [<ffffffff8128b3e8>] vfs_readdir+0x78/0xc0
> [  327.425263]  [<ffffffff8128b54c>] SyS_getdents+0x8c/0x110
> [  327.426173]  [<ffffffff83d919d8>] tracesys+0xe1/0xe6
>

Sasha, looks there is a race when sys_readdir() is run concurrently
on same directory, and the below patch may fix the race, could you test the
attachment patch to see if the use after free can be fixed?


Thanks,
-- 
Ming Lei

--047d7b6dc6ceffb9da04d8146b03
Content-Type: application/octet-stream; name="sysfs-fix-readdir.patch"
Content-Disposition: attachment; filename="sysfs-fix-readdir.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hedi1dpl0

ZGlmZiAtLWdpdCBhL2ZzL3N5c2ZzL2Rpci5jIGIvZnMvc3lzZnMvZGlyLmMKaW5kZXggMmZiZGZm
Ni4uOGY2OGVjYyAxMDA2NDQKLS0tIGEvZnMvc3lzZnMvZGlyLmMKKysrIGIvZnMvc3lzZnMvZGly
LmMKQEAgLTEwMDgsMTcgKzEwMDgsMjIgQEAgc3RhdGljIGludCBzeXNmc19yZWFkZGlyKHN0cnVj
dCBmaWxlICogZmlscCwgdm9pZCAqIGRpcmVudCwgZmlsbGRpcl90IGZpbGxkaXIpCiB7CiAJc3Ry
dWN0IGRlbnRyeSAqZGVudHJ5ID0gZmlscC0+Zl9wYXRoLmRlbnRyeTsKIAlzdHJ1Y3Qgc3lzZnNf
ZGlyZW50ICogcGFyZW50X3NkID0gZGVudHJ5LT5kX2ZzZGF0YTsKLQlzdHJ1Y3Qgc3lzZnNfZGly
ZW50ICpwb3MgPSBmaWxwLT5wcml2YXRlX2RhdGE7CisJc3RydWN0IHN5c2ZzX2RpcmVudCAqcG9z
OwogCWVudW0ga29ial9uc190eXBlIHR5cGU7CiAJY29uc3Qgdm9pZCAqbnM7CiAJaW5vX3QgaW5v
OworCWludCByZXQ7CiAKIAl0eXBlID0gc3lzZnNfbnNfdHlwZShwYXJlbnRfc2QpOwogCW5zID0g
c3lzZnNfaW5mbyhkZW50cnktPmRfc2IpLT5uc1t0eXBlXTsKIAorCW11dGV4X2xvY2soJnN5c2Zz
X211dGV4KTsKIAlpZiAoZmlscC0+Zl9wb3MgPT0gMCkgewogCQlpbm8gPSBwYXJlbnRfc2QtPnNf
aW5vOwotCQlpZiAoZmlsbGRpcihkaXJlbnQsICIuIiwgMSwgZmlscC0+Zl9wb3MsIGlubywgRFRf
RElSKSA9PSAwKQorCQltdXRleF91bmxvY2soJnN5c2ZzX211dGV4KTsKKwkJcmV0ID0gZmlsbGRp
cihkaXJlbnQsICIuIiwgMSwgZmlscC0+Zl9wb3MsIGlubywgRFRfRElSKTsKKwkJbXV0ZXhfbG9j
aygmc3lzZnNfbXV0ZXgpOworCQlpZiAoIXJldCkKIAkJCWZpbHAtPmZfcG9zKys7CiAJfQogCWlm
IChmaWxwLT5mX3BvcyA9PSAxKSB7CkBAIC0xMDI2LDE2ICsxMDMxLDE5IEBAIHN0YXRpYyBpbnQg
c3lzZnNfcmVhZGRpcihzdHJ1Y3QgZmlsZSAqIGZpbHAsIHZvaWQgKiBkaXJlbnQsIGZpbGxkaXJf
dCBmaWxsZGlyKQogCQkJaW5vID0gcGFyZW50X3NkLT5zX3BhcmVudC0+c19pbm87CiAJCWVsc2UK
IAkJCWlubyA9IHBhcmVudF9zZC0+c19pbm87Ci0JCWlmIChmaWxsZGlyKGRpcmVudCwgIi4uIiwg
MiwgZmlscC0+Zl9wb3MsIGlubywgRFRfRElSKSA9PSAwKQorCQltdXRleF91bmxvY2soJnN5c2Zz
X211dGV4KTsKKwkJcmV0ID0gZmlsbGRpcihkaXJlbnQsICIuLiIsIDIsIGZpbHAtPmZfcG9zLCBp
bm8sIERUX0RJUik7CisJCW11dGV4X2xvY2soJnN5c2ZzX211dGV4KTsKKwkJaWYgKCFyZXQpCiAJ
CQlmaWxwLT5mX3BvcysrOwogCX0KLQltdXRleF9sb2NrKCZzeXNmc19tdXRleCk7CisJcG9zID0g
ZmlscC0+cHJpdmF0ZV9kYXRhOwogCWZvciAocG9zID0gc3lzZnNfZGlyX3BvcyhucywgcGFyZW50
X3NkLCBmaWxwLT5mX3BvcywgcG9zKTsKIAkgICAgIHBvczsKIAkgICAgIHBvcyA9IHN5c2ZzX2Rp
cl9uZXh0X3BvcyhucywgcGFyZW50X3NkLCBmaWxwLT5mX3BvcywgcG9zKSkgewogCQljb25zdCBj
aGFyICogbmFtZTsKIAkJdW5zaWduZWQgaW50IHR5cGU7Ci0JCWludCBsZW4sIHJldDsKKwkJaW50
IGxlbjsKIAogCQluYW1lID0gcG9zLT5zX25hbWU7CiAJCWxlbiA9IHN0cmxlbihuYW1lKTsK
--047d7b6dc6ceffb9da04d8146b03--
