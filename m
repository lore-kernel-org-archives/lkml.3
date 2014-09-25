Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaIYJGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:06:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaIYJGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:06:40 -0400
Date: Thu, 25 Sep 2014 11:06:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, ilya.dryomov@inktank.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Message-ID: <20140925090619.GA5430@worktop>
References: <20140924081845.572814794@infradead.org>
 <1411633803.15810.12.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411633803.15810.12.camel@marge.simpson.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 10:30:03AM +0200, Mike Galbraith wrote:
> On Wed, 2014-09-24 at 10:18 +0200, Peter Zijlstra wrote: 
> > Hi,
> > 
> > This is a refresh of the nested sleep debug stuff which I posted as an RFC a
> > while back: lkml.kernel.org/r/20140804103025.478913141@infradead.org
> > 
> > Since then a number of issues identified by these patches have allready made
> > their way upstream:
> > 
> >     de713b57947a ("atm/svc: Fix blocking in wait loop")
> >     7c3af9752573 ("nfs: don't sleep with inode lock in lock_and_join_requests")
> > 
> > And I finally got some time to finish up these patches so we could merge them.
> > So please have a look and if nobody holllers we'll merge this 'soon'.
> 
> My DL980 hollered itself to death while booting.
> 
> [   39.587224] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff811021d0>] kauditd_thread+0x130/0x1e0
> [   39.706325] Modules linked in: iTCO_wdt(E) gpio_ich(E) iTCO_vendor_support(E) joydev(E) i7core_edac(E) lpc_ich(E) hid_generic(E) hpwdt(E) mfd_core(E) edac_core(E) bnx2(E) shpchp(E) sr_mod(E) ehci_pci(E) hpilo(E) netxen_nic(E) ipmi_si(E) cdrom(E) pcspkr(E) sg(E) acpi_power_meter(E) ipmi_msghandler(E) button(E) ext4(E) jbd2(E) mbcache(E) crc16(E) usbhid(E) radeon(E) ttm(E) drm_kms_helper(E) drm(E) i2c_algo_bit(E) uhci_hcd(E) ehci_hcd(E) usbcore(E) sd_mod(E) thermal(E) usb_common(E) processor(E) scsi_dh_hp_sw(E) scsi_dh_emc(E) scsi_dh_rdac(E) scsi_dh_alua(E) scsi_dh(E) ata_generic(E) ata_piix(E) libata(E) hpsa(E) cciss(E) scsi_mod(E)
> [   40.373599] CPU: 9 PID: 1974 Comm: kauditd Tainted: G            E  3.17.0-default #2
> [   40.506928] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
> [   40.613753]  0000000000001bd9 ffff88026f3d3d78 ffffffff815b2fc2 ffff88026f3d3db8
> [   40.728720]  ffffffff8106613c ffff88026f3d3da8 ffff88026b4fa110 0000000000000000
> [   40.816116]  0000000000000038 ffffffff8180ff47 ffff88026f3d3e58 ffff88026f3d3e18
> [   40.905088] Call Trace:
> [   40.938325]  [<ffffffff815b2fc2>] dump_stack+0x72/0x88
> [   41.000143]  [<ffffffff8106613c>] warn_slowpath_common+0x8c/0xc0
> [   41.067996]  [<ffffffff81066226>] warn_slowpath_fmt+0x46/0x50
> [   41.132669]  [<ffffffff811021d0>] ? kauditd_thread+0x130/0x1e0
> [   41.204105]  [<ffffffff811021d0>] ? kauditd_thread+0x130/0x1e0
> [   41.270699]  [<ffffffff8108d214>] __might_sleep+0x84/0xa0
> [   41.333979]  [<ffffffff8110224b>] kauditd_thread+0x1ab/0x1e0
> [   41.398612]  [<ffffffff810940c0>] ? try_to_wake_up+0x210/0x210
> [   41.465435]  [<ffffffff811020a0>] ? audit_printk_skb+0x70/0x70
> [   41.534628]  [<ffffffff810859db>] kthread+0xeb/0x100
> [   41.596562]  [<ffffffff810858f0>] ? kthread_freezable_should_stop+0x80/0x80
> [   41.678973]  [<ffffffff815b85bc>] ret_from_fork+0x7c/0xb0
> [   41.742073]  [<ffffffff810858f0>] ? kthread_freezable_should_stop+0x80/0x80

Cute,.. where exactly is that __might_sleep coming from; nothing obvious
there (then again, I'm half asleep) and stuff seems to have gotten
inlined.
