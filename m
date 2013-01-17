Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab3AQIEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:04:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29127 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262Ab3AQIE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:04:29 -0500
From: dev@snitselaar.org
To: james.l.morris@oracle.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerry Snitselaar <jerry.snitselaar@oracle.com>
Subject: [PATCH] security/device_cgroup: lock assert fails in dev_exception_clean()
Date: Thu, 17 Jan 2013 01:04:14 -0700
Message-Id: <1358409854-3574-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.8.1.191.g414c78c
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerry Snitselaar <jerry.snitselaar@oracle.com>

devcgroup_css_free() calls dev_exception_clean() without the devcgroup_mutex being locked.

Shutting down a kvm virt was giving me the following trace:

[36280.732764] ------------[ cut here ]------------
[36280.732778] WARNING: at /home/snits/dev/linux/security/device_cgroup.c:172 dev_exception_clean+0xa9/0xc0()
[36280.732782] Hardware name: Studio XPS 8100
[36280.732785] Modules linked in: xt_REDIRECT fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle bridge stp llc nf_conntrack_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter it87 hwmon_vid xt_state nf_conntrack ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq coretemp snd_seq_device crc32c_intel snd_pcm snd_page_alloc snd_timer snd broadcom tg3 serio_raw i7core_edac edac_core ptp pps_core lpc_ich pcspkr mfd_core soundcore microcode i2c_i801 nfsd auth_rpcgss nfs_acl lockd vhost_net sunrpc tun macvtap macvlan kvm_intel kvm uinput binfmt_misc autofs4 usb_storage firewire_ohci firewire_core crc_itu_t radeon drm_kms_helper ttm
[36280.732921] Pid: 933, comm: libvirtd Tainted: G        W    3.8.0-rc3-00307-g4c217de #1
[36280.732922] Call Trace:
[36280.732927]  [<ffffffff81044303>] warn_slowpath_common+0x93/0xc0
[36280.732930]  [<ffffffff8104434a>] warn_slowpath_null+0x1a/0x20
[36280.732932]  [<ffffffff812deaf9>] dev_exception_clean+0xa9/0xc0
[36280.732934]  [<ffffffff812deb2a>] devcgroup_css_free+0x1a/0x30
[36280.732938]  [<ffffffff810ccd76>] cgroup_diput+0x76/0x210
[36280.732941]  [<ffffffff8119eac0>] d_delete+0x120/0x180
[36280.732943]  [<ffffffff81195cff>] vfs_rmdir+0xef/0x130
[36280.732945]  [<ffffffff81195e47>] do_rmdir+0x107/0x1c0
[36280.732949]  [<ffffffff8132d17e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[36280.732951]  [<ffffffff81198646>] sys_rmdir+0x16/0x20
[36280.732954]  [<ffffffff8173bd82>] system_call_fastpath+0x16/0x1b
[36280.732956] ---[ end trace ca39dced899a7d9f ]---


Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
---
 security/device_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 19ecc8d..d794abc 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -215,7 +215,9 @@ static void devcgroup_css_free(struct cgroup *cgroup)
 	struct dev_cgroup *dev_cgroup;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
+	mutex_lock(&devcgroup_mutex);
 	dev_exception_clean(dev_cgroup);
+	mutex_unlock(&devcgroup_mutex);
 	kfree(dev_cgroup);
 }
 
-- 
1.8.1.191.g414c78c

