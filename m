Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3C3W05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 18:26:57 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:51918 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3C3W0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 18:26:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130326195601.GA5124@dhcp22.suse.cz>
References: <20130326195601.GA5124@dhcp22.suse.cz>
Date: Sat, 30 Mar 2013 18:26:53 -0400
Message-ID: <CA+4h6Hnhm-Ox_5dRdBH3C9Lh_qVNac8_oL=3ruy75jBX7xp9OQ@mail.gmail.com>
Subject: Re: [PATCH] drm: fix i_mapping and f_mapping initialization in
 drm_open in error path
From: Ilija Hadzic <ilijahadzic@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Marco Munderloh <munderl@tnt.uni-hannover.de>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec52c664d80d14104d92be20d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec52c664d80d14104d92be20d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This looks a bit like a hack and it doesn't look right, conceptually. If
the call fails, it should restore things as if nothing has ever happened
and overwriting old_mapping is not going to do the trick.

I think the right way to fix it would be to separately store the
original mapping for
filp->f_mapping and inode->i_mapping and restore it from their
respective temporary
variables if drm_open_helper or drm_setup fail. Attached is a quick
patch to show you
what I have in mind, can you please test it and if it solves your
problem, I'll send it to
Dave.

By the way, what specific course of action reproduces the problem? It
requires drm_open
to fail, but is there anything else that you do?

thanks,

Ilija

On Tue, Mar 26, 2013 at 3:56 PM, Michal Hocko <mhocko@suse.cz> wrote:
> Hi,
> the patch bellow fixes a nullptr dereference reported with OpenSUSE12.3.
> I am not familiar with the area so I have no idea whether this is the
> right way to go but after applying this patch the problem is not
> reproducible anymore
> If the patch is correct then please mark it for stable (3.7+).
>
> Thanks!
> ---
> From a786a701bd6c277329e2b788fea9a69b1c3ced2e Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Tue, 26 Mar 2013 19:04:40 +0100
> Subject: [PATCH] drm: fix i_mapping and f_mapping initialization in drm_o=
pen
>  in error path
>
> Starting with fdb40a08 (drm: set dev_mapping before calling
> drm_open_helper) inode and file mappings are set to old_mapping in the
> error path. old_mapping can be NULL, however, which is handled by
> initializing dev_mapping to default inode->i_data. old_mapping is left
> intact though so the both inode's and filep's mapping will still point
> to NULL which is unexpected and can it results in crashes later one.
>
> Marco Munderloh has reported such crashes:
>  BUG: unable to handle kernel NULL pointer dereference at 000000000000005=
8
>  IP: [<ffffffff81190be4>] drop_pagecache_sb+0x74/0xe0
>  PGD 252bc1067 PUD 253d11067 PMD 0
>  Oops: 0000 [#1] SMP
>  Modules linked in: fuse af_packet xt_tcpudp xt_pkttype xt_LOG xt_limit b=
nep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
> ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle =
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_=
ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_table=
s cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq snd=
_hda_codec_hdmi mperf coretemp snd_hda_codec_realtek snd_hda_intel snd_hda_=
codec snd_hwdep kvm_intel snd_pcm arc4 snd_seq snd_timer snd_seq_device kvm=
 iwldvm mac80211 snd uvcvideo crc32c_intel videobuf2_core videodev ghash_cl=
mulni_intel aesni_intel ablk_helper cryptd lrw videobuf2_vmalloc aes_x86_64=
 iTCO_wdt xts tpm_infineon mei r8169 videobuf2_memops iTCO_vendor_support s=
r_mod lpc_ich iwlwifi gf128mul sony_laptop rts_pstor(C) cdrom i2c_i801 tpm_=
tis tpm tpm_bios battery mfd_core soundcore snd_page_alloc cfg80211 rfkill =
ac sg microcode pcspkr autofs4 xhci_hcd ehci_hcd usbcore usb_common radeon =
i915 video ttm drm_kms_helper drm i2c_algo_bit thermal button processor the=
rmal_sys scsi_dh_emc scsi_dh_rdac scsi_dh_hp_sw scsi_dh_alua
> scsi_dh
>  CPU 0
>  Pid: 1452, comm: bash Tainted: G         C   3.7.10-1.1-default
> ation VPCSA4W9E/VAIO
>  RIP: 0010:[<ffffffff81190be4>]  [<ffffffff81190be4>] drop_pagecache_sb+0=
x74/0xe0
>  RSP: 0018:ffff880252bc9e18  EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff88024ecb7db0 RCX: 0000000000000002
>  RDX: 0000000000000007 RSI: ffff88024f63a670 RDI: ffff88024ecb7e38
>  RBP: ffff88024ecb7e38 R08: dead000000200200 R09: 0000000000000000
>  R10: 0000000000000001 R11: 0000000000000210 R12: ffff880254d588a0
>  R13: ffff88024fcb25e8 R14: ffffffff81190b70 R15: ffffffffffffffea
>  FS:  00007fad2b9ed700(0000) GS:ffff88025fa00000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000058 CR3: 0000000252ad2000 CR4: 00000000000407f0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process bash (pid: 1452, threadinfo ffff880252bc8000, task ffff880253d32=
1c0)
>  Stack:
>   0000000000000001 ffff880254d58800 ffff880254e94800 ffff880254d58868
>   0000000000000000 ffffffff8116a499 0000000000000000 0000000000000001
>   ffffffff81a228a0 ffff880252bc9f50 0000000000000002 ffffffff81190cce
>  Call Trace:
>   [<ffffffff8116a499>] iterate_supers+0xd9/0xe0
>   [<ffffffff81190cce>] drop_caches_sysctl_handler+0x7e/0x90
>   [<ffffffff811d0e26>] proc_sys_call_handler.isra.10+0xc6/0xe0
>   [<ffffffff81166fd7>] vfs_write+0xa7/0x180
>   [<ffffffff81167321>] sys_write+0x51/0xa0
>   [<ffffffff8154f2ed>] system_call_fastpath+0x1a/0x1f
>   [<00007fad2ae959c0>] 0x7fad2ae959bf
>  Code: 01 00 00 49 39 c4 48 8d 98 00 ff ff ff 74 68 48 8d ab 88 00 00 00 =
48 89 ef e8 49 69 3b 00 f6 83 a0 00 00 00 38 75 d0 48 8b 43 30 <48> 83 78 5=
8 00 74 c5 48 89 df e8 dd ef fe ff 66 83 45 00 01 66
>  RIP  [<ffffffff81190be4>] drop_pagecache_sb+0x74/0xe0
>   RSP <ffff880252bc9e18>
>  CR2: 0000000000000058
>
> when dropping caches when inode with NULL i_mapping is encountered. Or a
> different one when umounting devtmpfs:
>  BUG: unable to handle kernel NULL pointer dereference at 000000000000006=
8
>  IP: [<ffffffff81122001>] shmem_evict_inode+0x11/0x130
>  PGD 0
>  Oops: 0000 [#1] SMP
>  Modules linked in: xt_tcpudp xt_pkttype xt_LOG xt_limit af_packet ip6t_R=
EJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw =
xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_b=
roadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntra=
ck bnep bluetooth ip6table_filter ip6_tables cpufreq_conservative x_tables =
cpufreq_userspace cpufreq_powersave snd_hda_codec_hdmi snd_hda_codec_realte=
k acpi_cpufreq snd_hda_intel mperf snd_hda_codec coretemp snd_hwdep kvm_int=
el snd_pcm kvm arc4 snd_seq iwldvm mac80211 crc32c_intel ghash_clmulni_inte=
l snd_timer aesni_intel snd_seq_device iTCO_wdt uvcvideo videobuf2_core iwl=
wifi videodev sony_laptop videobuf2_vmalloc videobuf2_memops ablk_helper iT=
CO_vendor_support cryptd cfg80211 tpm_infineon r8169 sr_mod cdrom mei snd l=
pc_ich battery lrw aes_x86_64 xts rfkill i2c_i801 pcspkr mfd_core tpm_tis a=
c gf128mul tpm tpm_bios soundcore snd_page_alloc sg microcode autofs4 xhci_=
hcd ehci_hcd radeon(-) i915 ttm drm_kms_helper usbcore usb_common drm therm=
al i2c_algo_bit video button processor thermal_sys scsi_dh_emc scsi_dh_rdac=
 scsi_dh_hp_sw scsi_dh_alua scsi_dh
>  CPU 1 <4>[   44.175256] Pid: 29, comm: kdevtmpfs Tainted: G        W    =
3.7.10-1-default-patched #4 Sony Corpora
> tion VPCSA4W9E/VAIO
>  RIP: 0010:[<ffffffff81122001>]  [<ffffffff81122001>] shmem_evict_inode+0=
x11/0x130
>  RSP: 0018:ffff880254ed3d18  EFLAGS: 00010296
>  RAX: 0000000000000000 RBX: ffff88024fb185e8 RCX: 0000000000000034
>  RDX: 0000000000002433 RSI: 0000000000000c11 RDI: ffff88024fb185e8
>  RBP: ffff88024fb186e8 R08: 1038000000000000 R09: 024fb186881c0000
>  R10: fd924f0d6445a207 R11: 0000000000000000 R12: ffffffff8161b640
>  R13: ffff88024fb185e8 R14: 0000000000000000 R15: 0000000000000000
>  FS:  0000000000000000(0000) GS:ffff88025fa40000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000068 CR3: 0000000001a0c000 CR4: 00000000000407e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process kdevtmpfs (pid: 29, threadinfo ffff880254ed2000, task ffff880254=
ed0080)
>  Stack:
>   ffff88024fb185e8 ffff88024fb185e8 ffff88024fb186e8 ffffffff8161b640
>   0000000000000000 ffffffff8117f5f3 ffff88024e453a80 ffff88024fb185e8
>   0000000000000000 ffffffff8117b778 0000000000000000 ffff88024e453a80
>  Call Trace:
>   [<ffffffff8117f5f3>] evict+0xa3/0x190
>   [<ffffffff8117b778>] d_delete+0x148/0x180
>   [<ffffffff81171d77>] vfs_unlink+0xf7/0x110
>   [<ffffffff81386ab2>] handle_remove+0x202/0x250
>   [<ffffffff81386de5>] devtmpfsd+0xd5/0x130
>   [<ffffffff81066273>] kthread+0xb3/0xc0
>   [<ffffffff81549c3c>] ret_from_fork+0x7c/0xb0
>  Code: 7b 30 b9 01 00 00 00 31 d2 4c 89 f6 e8 69 e3 00 00 e9 23 ff ff ff =
0f 1f 40 00 41 55 49 89 fd 41 54 55 53 48 83 ec 08 48 8b 47 30 <48> 81 78 6=
8 00 b7 61 81 74 75 48 8b 7f a8 4d 8d 65 90 e8 b8 1f
>  RIP  [<ffffffff81122001>] shmem_evict_inode+0x11/0x130
>  RSP <ffff880254ed3d18>
>  CR2: 0000000000000068
>
> This patch fixes that by initializating old_mapping to the inode->i_data
> same as dev_mapping.
>
> Reported-and-tested-by: Marco Munderloh <munderl@tnt.uni-hannover.de>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  drivers/gpu/drm/drm_fops.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
> index 133b413..62a5435 100644
> --- a/drivers/gpu/drm/drm_fops.c
> +++ b/drivers/gpu/drm/drm_fops.c
> @@ -139,7 +139,7 @@ int drm_open(struct inode *inode, struct file *filp)
>         mutex_lock(&dev->struct_mutex);
>         old_mapping =3D dev->dev_mapping;
>         if (old_mapping =3D=3D NULL)
> -               dev->dev_mapping =3D &inode->i_data;
> +               dev->dev_mapping =3D old_mapping =3D &inode->i_data;
>         /* ihold ensures nobody can remove inode with our i_data */
>         ihold(container_of(dev->dev_mapping, struct inode, i_data));
>         inode->i_mapping =3D dev->dev_mapping;
> --
> 1.7.10.4
>
> --
> Michal Hocko
> SUSE Labs

--bcaec52c664d80d14104d92be20d
Content-Type: application/octet-stream; 
	name="0001-drm-correctly-restore-mappings-if-drm_open-fails.patch"
Content-Disposition: attachment; 
	filename="0001-drm-correctly-restore-mappings-if-drm_open-fails.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hexclehk0

RnJvbSBlNWY3OWQ5OTZhODQ4N2NmNTM0OWMxOGRmNWU2OGFiY2JmYTg4NzY4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBJbGlqYSBIYWR6aWMgPGloYWR6aWNAcmVzZWFyY2guYmVsbC1s
YWJzLmNvbT4KRGF0ZTogU2F0LCAzMCBNYXIgMjAxMyAxODoyMDozNSAtMDQwMApTdWJqZWN0OiBb
UEFUQ0hdIGRybTogY29ycmVjdGx5IHJlc3RvcmUgbWFwcGluZ3MgaWYgZHJtX29wZW4gZmFpbHMK
CklmIGZpcnN0IGRybV9vcGVuIGZhaWxzLCB0aGUgZXJyb3IgcGF0Y2ggd2lsbCBpbmNvcnJlY3Rs
eQpyZXN0b3JlIGlub2RlJ3MgbWFwcGluZyB0byBOVUxMLiBUaGlzIGNhbiBjYXVzZSB0aGUKY3Jh
c2ggbGF0ZXIgb24uIEZpeCBieSBzZXBhcmF0ZWx5IHN0b3JpbmcgYXdheSBhbGwKbWFwcGluZyBw
b2ludGVycyB0aGF0IGRybV9vcGVuIGNhbiB0b3VjaCBhbmQgcmVzdG9yZQplYWNoIGZyb20gaXRz
IG93biByZXNwZWN0aXZlIHZhcmlhYmxlIGlmIHRoZSBjYWxsIGZhaWxzLgoKUmVmZXJlbmNlOgpo
dHRwOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL2FyY2hpdmVzL2RyaS1kZXZlbC8yMDEzLU1hcmNo
LzAzNjU2NC5odG1sCgpSZXBvcnRlZC1ieTogTWFyY28gTXVuZGVybG9oIDxtdW5kZXJsQHRudC51
bmktaGFubm92ZXIuZGU+ClNpZ25lZC1vZmYtYnk6IElsaWphIEhhZHppYyA8aWhhZHppY0ByZXNl
YXJjaC5iZWxsLWxhYnMuY29tPgpDYzogTWljaGFsIEhvY2tvIDxtaG9ja29Ac3VzZS5jej4KQ2M6
IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKClNpZ25lZC1vZmYtYnk6IElsaWphIEhhZHppYyA8aWhh
ZHppY0ByZXNlYXJjaC5iZWxsLWxhYnMuY29tPgotLS0KIGRyaXZlcnMvZ3B1L2RybS9kcm1fZm9w
cy5jIHwgOCArKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vZHJtX2ZvcHMuYyBiL2RyaXZl
cnMvZ3B1L2RybS9kcm1fZm9wcy5jCmluZGV4IDEzZmRjZDEuLjI0N2Y0NGQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvZ3B1L2RybS9kcm1fZm9wcy5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fZm9w
cy5jCkBAIC0xMjMsNiArMTIzLDggQEAgaW50IGRybV9vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUs
IHN0cnVjdCBmaWxlICpmaWxwKQogCWludCByZXRjb2RlID0gMDsKIAlpbnQgbmVlZF9zZXR1cCA9
IDA7CiAJc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm9sZF9tYXBwaW5nOworCXN0cnVjdCBhZGRyZXNz
X3NwYWNlICpvbGRfaW1hcHBpbmc7CisJc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm9sZF9mbWFwcGlu
ZzsKIAogCW1pbm9yID0gaWRyX2ZpbmQoJmRybV9taW5vcnNfaWRyLCBtaW5vcl9pZCk7CiAJaWYg
KCFtaW5vcikKQEAgLTEzNyw2ICsxMzksOCBAQCBpbnQgZHJtX29wZW4oc3RydWN0IGlub2RlICpp
bm9kZSwgc3RydWN0IGZpbGUgKmZpbHApCiAJaWYgKCFkZXYtPm9wZW5fY291bnQrKykKIAkJbmVl
ZF9zZXR1cCA9IDE7CiAJbXV0ZXhfbG9jaygmZGV2LT5zdHJ1Y3RfbXV0ZXgpOworCW9sZF9mbWFw
cGluZyA9IGZpbHAtPmZfbWFwcGluZzsKKwlvbGRfaW1hcHBpbmcgPSBpbm9kZS0+aV9tYXBwaW5n
OwogCW9sZF9tYXBwaW5nID0gZGV2LT5kZXZfbWFwcGluZzsKIAlpZiAob2xkX21hcHBpbmcgPT0g
TlVMTCkKIAkJZGV2LT5kZXZfbWFwcGluZyA9ICZpbm9kZS0+aV9kYXRhOwpAQCAtMTU5LDggKzE2
Myw4IEBAIGludCBkcm1fb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmls
cCkKIAogZXJyX3VuZG86CiAJbXV0ZXhfbG9jaygmZGV2LT5zdHJ1Y3RfbXV0ZXgpOwotCWZpbHAt
PmZfbWFwcGluZyA9IG9sZF9tYXBwaW5nOwotCWlub2RlLT5pX21hcHBpbmcgPSBvbGRfbWFwcGlu
ZzsKKwlmaWxwLT5mX21hcHBpbmcgPSBvbGRfZm1hcHBpbmc7CisJaW5vZGUtPmlfbWFwcGluZyA9
IG9sZF9pbWFwcGluZzsKIAlpcHV0KGNvbnRhaW5lcl9vZihkZXYtPmRldl9tYXBwaW5nLCBzdHJ1
Y3QgaW5vZGUsIGlfZGF0YSkpOwogCWRldi0+ZGV2X21hcHBpbmcgPSBvbGRfbWFwcGluZzsKIAlt
dXRleF91bmxvY2soJmRldi0+c3RydWN0X211dGV4KTsKLS0gCjEuOC4xLjUKCg==
--bcaec52c664d80d14104d92be20d--
