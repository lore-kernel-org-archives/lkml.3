Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaHTCuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 22:50:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:26058 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaHTCuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 22:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,898,1400050800"; 
   d="scan'208";a="587240101"
Message-ID: <53F40CF8.8050504@linux.intel.com>
Date: Wed, 20 Aug 2014 10:50:32 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>
CC: viro@zeniv.linux.org.uk, adobriyan@gmail.com
Subject: Re: WARNING: CPU: 6 PID: 79 at fs/proc/generic.c:521 remove_proc_entry+0x170/0x180()
References: <alpine.DEB.2.19.4.1408191754390.2758@trent.utfs.org>
In-Reply-To: <alpine.DEB.2.19.4.1408191754390.2758@trent.utfs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kujau,
	It seems like a different issue, something wrong with
void nfs_fs_proc_net_exit(struct net *net)
{
        struct nfs_net *nn = net_generic(net, nfs_net_id);

        remove_proc_entry("volumes", nn->proc_nfsfs);
        remove_proc_entry("servers", nn->proc_nfsfs);
        remove_proc_entry("fs/nfsfs", NULL);
}

But I'm not familiar with this piece of code.
Regards!
Gerry

On 2014/8/20 9:04, Christian Kujau wrote:
> Hi,
> 
> the warning below appeared while booting 3.17.0-rc1. I haven't seen the 
> warning before, but found a recent report on oops.kernel.org:
> 
> http://oops.kernel.org/oops/warning-at-fs-proc-generic-c521-remove_proc_entry0x18f-0x1a0/
> 
> and also reports from July 2014, where the issue was reported to be fixed:
> 
> https://lkml.org/lkml/2014/7/16/9
> https://lkml.org/lkml/2014/7/18/116
> 
> And the patch really made it into 3.17.0-rc1, so maybe it's something else 
> this time. Details and .config: http://nerdbynature.de/bits/3.17-rc1/
> 
> Thanks,
> Christian.
> 
> ------------[ cut here ]------------
> WARNING: CPU: 6 PID: 79 at /usr/local/src/linux-git/fs/proc/generic.c:521 remove_proc_entry+0x170/0x180()
> remove_proc_entry: removing non-empty directory 'fs/nfsfs', leaking at least 'volumes'
> Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memops 
> videobuf2_core v4l2_common btusb videodev bluetooth hid_logitech_dj 
> sha256_ssse3 sha256_generic twofish_generic twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common 
> nfs xts lockd sunrpc arc4 coretemp x86_pkg_temp_thermal usbhid 
> intel_powerclamp hid iwldvm kvm_intel
>  mac80211 kvm snd_hda_codec_hdmi i2c_i801 iwlwifi cfg80211 thinkpad_acpi 
> snd_hda_codec_conexant snd_hda_codec_generic nvram hwmon led_class wmi 
> rtc_cmos i915 snd_hda_intel 
> i2c_algo_bit snd_hda_controller drm_kms_helper snd_hda_codec drm snd_hwdep 
> snd_pcm i2ccore snd_timer snd soundcore fuse autofs4 btrfs xor raid6_pq 
> aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd sr_mod cdrom sg ehci_pci 
> ehci_hcd xhci_hcd
> CPU: 6 PID: 79 Comm: kworker/u16:6 Not tainted 3.17.0-rc1 #1
> Hardware name: LENOVO 6277CTO/6277CTO, BIOS HEET42WW (1.23 ) 01/27/2014
> Workqueue: netns cleanup_net
>  0000000000000009 ffffffff8149c1e2 ffff880406c8fd18 ffffffff8104ee6d
>  ffff880406701580 ffff880406c8fd68 0000000000000005 ffffffffc0883bae
>  ffffffffc0883bb1 ffffffff8104eed7 ffffffff815b1578 ffff880400000030
> Call Trace:
>  [<ffffffff8149c1e2>] ? dump_stack+0x41/0x51
>  [<ffffffff8104ee6d>] ? warn_slowpath_common+0x6d/0x90
>  [<ffffffff8104eed7>] ? warn_slowpath_fmt+0x47/0x50
>  [<ffffffff811955d1>] ? proc_entry_rundown+0x41/0x80
>  [<ffffffff81199b50>] ? remove_proc_entry+0x170/0x180
>  [<ffffffffc0873a79>] ? nfs_net_exit+0x9/0x20 [nfs]
>  [<ffffffff813e5951>] ? ops_exit_list.isra.2+0x31/0x60
>  [<ffffffff813e6150>] ? cleanup_net+0x100/0x1e0
>  [<ffffffff8106316b>] ? process_one_work+0x16b/0x3b0
>  [<ffffffff81063ed3>] ? worker_thread+0x63/0x490
>  [<ffffffff81063e70>] ? rescuer_thread+0x280/0x280
>  [<ffffffff8106848a>] ? kthread+0xca/0xe0
>  [<ffffffff810683c0>] ? kthread_create_on_node+0x170/0x170
>  [<ffffffff814a1b7c>] ? ret_from_fork+0x7c/0xb0
>  [<ffffffff810683c0>] ? kthread_create_on_node+0x170/0x170
> ---[ end trace c92165dd3f372cf6 ]---
> 
> 
