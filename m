Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3KDPNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:13:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab3KDPNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:13:20 -0500
Date: Mon, 4 Nov 2013 15:13:17 +0000
From: Mel Gorman <mgorman@suse.de>
To: Don Morris <don.morris@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: soft lockup - CPU#8 stuck for 22s!
Message-ID: <20131104151317.GA6653@suse.de>
References: <5266B5F2.5070102@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5266B5F2.5070102@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 01:29:22PM -0400, Don Morris wrote:
> Greetings, all.
> 
> Just wanted to drop this out there to see if it rang any bells.
> I've been getting a soft lockup (numad thread stuck on a cpu
> while attempting to attach a task to a cgroup) for a while now,
> but I thought it was only happening when I applied Mel Gorman's
> set of AutoNUMA patches. Today, however, it happened on a stock
> 3.12rc3 kernel as well, so it is in the baseline. And before
> anyone asks, I wanted to make sure directed numa activities
> such as numad would do interacted safely with the AutoNUMA
> stuff so that's why I was running with both enabled.
> 
> I believe this started in the 3.11 timeframe (and I'll try to
> bisect to narrow things down).
> 
> The problem/reproduction environment is:
> 	+ Centos 6.4
> 	/* The next three lines are to get numad running */
> 	+ mkdir /cgroup/cpuset
> 	+ mount cgroup -t cgroup -o cpuset /cgroup/cpuset
> 	+ service numad start
> 	+ loop running the AutoNUMA tests available at:
> 	git://gitorious.org/autonuma-benchmark/autonuma-benchmark.git
> 
> How long it takes to hit this varies -- since it looks like it
> is not due to Mel's changes at all, a stress test for cgroup
> interactions would likely kick it faster (anyone care to point
> me at one?).
> 

I ran this a few times in different configurations and was unable to
reproduce the problem. numad is certainly runnign because I can see
its effect.

> /var/log/messages output attached, trimmed to just one boot+instance
> of the problem.
> 
> Oct 22 11:05:10 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 22s!
> [numad:27384]
> Oct 22 11:05:10 hornet2 kernel: Modules linked in: ebtable_nat ebtables
> xt_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc
> ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables
> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack
> ip6table_filter ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun
> kvm_intel kvm uinput hp_wmi sparse_keymap rfkill snd_usb_audio
> snd_usbmidi_lib snd_rawmidi acpi_cpufreq freq_table iTCO_wdt
> iTCO_vendor_support sg microcode serio_raw pcspkr sb_edac edac_core wmi
> i2c_i801 lpc_ich mfd_core xhci_hcd e1000e ptp pps_core ioatdma dca
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore
> snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_t10dif
> crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahci
> pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm
> drm_kms_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log
> dm_mod
> Oct 22 11:05:10 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not
> tainted 3.12.0-rc3+ #1
> Oct 22 11:05:10 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620
> Workstation/158A, BIOS J61 v03.15 05/09/2013
> Oct 22 11:05:10 hornet2 kernel: task: ffff88070e9c60c0 ti:
> ffff88070e520000 task.ti: ffff88070e520000
> Oct 22 11:05:10 hornet2 kernel: RIP: 0010:[<ffffffff8154256c>]
> [<ffffffff8154256c>] _raw_read_lock+0xc/0x20

I assume it's the css_set_lock that is causing the problem. Someone
somewhere has gone to sleep forever holding that lock or there is an
error path that is not releasing it. Does sysrq-t reveal what might have
gone asleep with the lock held? None of the processes currently running
looked liks obvious candidates.

-- 
Mel Gorman
SUSE Labs
