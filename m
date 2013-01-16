Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3APMPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:15:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3APMPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:15:46 -0500
Date: Wed, 16 Jan 2013 12:15:43 +0000
From: thornber@redhat.com
To: device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software for
 Linux kernel
Message-ID: <20130116121542.GB3869@raspberrypi>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116104546.GA3869@raspberrypi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:45:47AM +0000, thornber@redhat.com wrote:
> Hi Amit,
> 
> I'll look through EnhanceIO this week.

I just ran the code through sparse and it throws up a lot of warnings.
Most of these trivial; functions that should be declared static.  But
some are more concerning, like the 'different address spaces' ones.
If you're not sure how to fix the 'context imbalance' ones ping me and
I'll write a patch for you.

On another note I see linux_os.h and os.h.  Which contain things like:

#define SPIN_LOCK_INIT                  spin_lock_init
#define SPIN_LOCK_IRQSAVE(l, f)         spin_lock_irqsave(l, f)
#define SPIN_UNLOCK_IRQRESTORE(l, f)    spin_unlock_irqrestore(l, f)
#define SPIN_LOCK_IRQSAVE_FLAGS(l)      do { long unsigned int f; spin_lock_irqsave(l, f); *(l##_flags) = f; }\
 while (0)
#define SPIN_UNLOCK_IRQRESTORE_FLAGS(l) do { long unsigned int f = *(l##_flags); spin_unlock_irqrestore(l, f);\
 } while (0)

You wont get the code upstream if it has an OS abstraction layer like
this.  Other people have tried.

- Joe


drivers/block/enhanceio/eio_ioctl.c:50:52: warning: incorrect type in argument 2 (different address spaces)
drivers/block/enhanceio/eio_ioctl.c:50:52:    expected void const [noderef] <asn:1>*from
drivers/block/enhanceio/eio_ioctl.c:50:52:    got struct cache_rec_short [usertype] *<noident>
drivers/block/enhanceio/eio_ioctl.c:70:52: warning: incorrect type in argument 2 (different address spaces)
drivers/block/enhanceio/eio_ioctl.c:70:52:    expected void const [noderef] <asn:1>*from
drivers/block/enhanceio/eio_ioctl.c:70:52:    got struct cache_rec_short [usertype] *<noident>
drivers/block/enhanceio/eio_ioctl.c:86:52: warning: incorrect type in argument 2 (different address spaces)
drivers/block/enhanceio/eio_ioctl.c:86:52:    expected void const [noderef] <asn:1>*from
drivers/block/enhanceio/eio_ioctl.c:86:52:    got struct cache_rec_short [usertype] *<noident>
drivers/block/enhanceio/eio_ioctl.c:99:43: warning: incorrect type in argument 1 (different address spaces)
drivers/block/enhanceio/eio_ioctl.c:99:43:    expected void [noderef] <asn:1>*dst
drivers/block/enhanceio/eio_ioctl.c:99:43:    got unsigned long long [usertype] *<noident>
drivers/block/enhanceio/eio_ioctl.c:118:52: warning: incorrect type in argument 2 (different address spaces)
drivers/block/enhanceio/eio_ioctl.c:118:52:    expected void const [noderef] <asn:1>*from
drivers/block/enhanceio/eio_ioctl.c:118:52:    got struct cache_rec_short [usertype] *<noident>
drivers/block/enhanceio/eio_ioctl.c:134:52: warning: incorrect type in argument 2 (different address spaces)
drivers/block/enhanceio/eio_ioctl.c:134:52:    expected void const [noderef] <asn:1>*from
drivers/block/enhanceio/eio_ioctl.c:134:52:    got struct cache_rec_short [usertype] *<noident>
  CC      drivers/block/enhanceio/eio_ioctl.o
drivers/block/enhanceio/eio_conf.c:47:16: warning: symbol 'cache_list_head' was not declared. Should it be sta\
tic?
drivers/block/enhanceio/eio_conf.c:48:20: warning: symbol '_kcached_wq' was not declared. Should it be static?
drivers/block/enhanceio/eio_conf.c:50:19: warning: symbol '_job_cache' was not declared. Should it be static?
drivers/block/enhanceio/eio_conf.c:51:19: warning: symbol '_io_cache' was not declared. Should it be static?
drivers/block/enhanceio/eio_conf.c:52:11: warning: symbol '_job_pool' was not declared. Should it be static?
drivers/block/enhanceio/eio_conf.c:53:11: warning: symbol '_io_pool' was not declared. Should it be static?
drivers/block/enhanceio/eio_conf.c:55:10: warning: symbol 'nr_cache_jobs' was not declared. Should it be stati\
c?
drivers/block/enhanceio/eio_conf.c:59:1: warning: symbol 'ssd_rm_list' was not declared. Should it be static?
drivers/block/enhanceio/eio_conf.c:60:5: warning: symbol 'ssd_rm_list_not_empty' was not declared. Should it b\
e static?
drivers/block/enhanceio/eio_conf.c:61:12: warning: symbol 'ssd_rm_list_lock' was not declared. Should it be st\
atic?
drivers/block/enhanceio/eio_conf.c:63:22: warning: symbol 'eio_control' was not declared. Should it be static?
drivers/block/enhanceio/eio_conf.c:65:5: warning: symbol 'eio_force_warm_boot' was not declared. Should it be \
static?
drivers/block/enhanceio/eio_conf.c:2101:1: warning: symbol 'eio_status_info' was not declared. Should it be st\
atic?
drivers/block/enhanceio/eio_conf.c:2446:1: warning: symbol 'eio_init' was not declared. Should it be static?
drivers/block/enhanceio/eio_conf.c:2494:1: warning: symbol 'eio_exit' was not declared. Should it be static?
  CC      drivers/block/enhanceio/eio_conf.o
drivers/block/enhanceio/eio_main.c:3157:53: warning: Using plain integer as NULL pointer
drivers/block/enhanceio/eio_main.c:1095:34: warning: Using plain integer as NULL pointer
drivers/block/enhanceio/eio_main.c:1392:33: warning: Using plain integer as NULL pointer
drivers/block/enhanceio/eio_main.c:141:1: warning: symbol 'eio_io_async_pages' was not declared. Should it be \
static?
drivers/block/enhanceio/eio_main.c:171:1: warning: symbol 'eio_io_async_bvec' was not declared. Should it be s\
tatic?
drivers/block/enhanceio/eio_main.c:275:1: warning: symbol 'eio_disk_io_callback' was not declared. Should it b\
e static?
drivers/block/enhanceio/eio_main.c:359:1: warning: symbol 'eio_io_callback' was not declared. Should it be sta\
tic?
drivers/block/enhanceio/eio_main.c:3103:16: warning: symbol 'setup_bio_vecs' was not declared. Should it be st\
atic?
  CHECK   drivers/block/enhanceio/eio_mem.c
drivers/block/enhanceio/eio_main.c:1399:9: warning: context imbalance in 'eio_enq_mdupdate' - different lock c\
ontexts for basic block
drivers/block/enhanceio/eio_policy.c:25:1: warning: symbol 'eio_policy_list' was not declared. Should it be st\
atic?
  CC      drivers/block/enhanceio/eio_policy.o
  CHECK   drivers/block/enhanceio/eio_setlru.c
drivers/block/enhanceio/eio_procfs.c:56:1: warning: symbol 'eio_zerostats_sysctl' was not declared. Should it \
be static?
drivers/block/enhanceio/eio_procfs.c:120:1: warning: symbol 'eio_mem_limit_pct_sysctl' was not declared. Shoul\
d it be static?
drivers/block/enhanceio/eio_procfs.c:164:1: warning: symbol 'eio_error_inject_sysctl' was not declared. Should\
 it be static?
drivers/block/enhanceio/eio_procfs.c:186:1: warning: symbol 'eio_clean_sysctl' was not declared. Should it be \
static?
drivers/block/enhanceio/eio_procfs.c:263:1: warning: symbol 'eio_dirty_high_threshold_sysctl' was not declared\
. Should it be static?
drivers/block/enhanceio/eio_procfs.c:338:1: warning: symbol 'eio_dirty_low_threshold_sysctl' was not declared.\
 Should it be static?
drivers/block/enhanceio/eio_procfs.c:419:1: warning: symbol 'eio_dirty_set_high_threshold_sysctl' was not decl\
ared. Should it be static?
drivers/block/enhanceio/eio_procfs.c:497:1: warning: symbol 'eio_dirty_set_low_threshold_sysctl' was not decla\
red. Should it be static?
drivers/block/enhanceio/eio_procfs.c:582:1: warning: symbol 'eio_autoclean_threshold_sysctl' was not declared.\
 Should it be static?       
drivers/block/enhanceio/eio_procfs.c:651:1: warning: symbol 'eio_time_based_clean_interval_sysctl' was not dec\
lared. Should it be static?
drivers/block/enhanceio/eio_procfs.c:734:1: warning: symbol 'eio_control_sysctl' was not declared. Should it b\
e static?
drivers/block/enhanceio/eio_procfs.c:1276:11: warning: symbol 'invalidate_spin_lock_flags' was not declared. S\
hould it be static?
  CC      drivers/block/enhanceio/eio_procfs.o
  CC      drivers/block/enhanceio/eio_setlru.o
  CHECK   drivers/block/enhanceio/eio_subr.c
drivers/block/enhanceio/eio_subr.c:34:11: warning: symbol '_job_lock_flags' was not declared. Should it be sta\
tic?
drivers/block/enhanceio/eio_subr.c:40:1: warning: symbol '_io_jobs' was not declared. Should it be static?
drivers/block/enhanceio/eio_subr.c:41:1: warning: symbol '_disk_read_jobs' was not declared. Should it be stat\
ic?
drivers/block/enhanceio/eio_subr.c:74:20: warning: symbol 'eio_pop' was not declared. Should it be static?
drivers/block/enhanceio/eio_subr.c:92:1: warning: symbol 'eio_push' was not declared. Should it be static?
drivers/block/enhanceio/eio_subr.c:110:1: warning: symbol 'eio_push_io' was not declared. Should it be static?
drivers/block/enhanceio/eio_subr.c:216:1: warning: symbol 'eio_sync_endio' was not declared. Should it be stat\
ic?
  CC      drivers/block/enhanceio/eio_subr.o
  CHECK   drivers/block/enhanceio/eio_ttc.c
  CHECK   drivers/block/enhanceio/eio_fifo.c
drivers/block/enhanceio/eio_ttc.c:89:24: warning: non-ANSI function declaration of function 'eio_create_misc_d\
evice'
drivers/block/enhanceio/eio_ttc.c:95:24: warning: non-ANSI function declaration of function 'eio_delete_misc_d\
evice'
drivers/block/enhanceio/eio_ttc.c:34:25: warning: symbol 'eio_ttc_lock' was not declared. Should it be static?
drivers/block/enhanceio/eio_ttc.c:37:5: warning: symbol 'eio_reboot_notified' was not declared. Should it be s\
tatic?
drivers/block/enhanceio/eio_ttc.c:520:39: warning: incorrect type in argument 2 (different address spaces)
drivers/block/enhanceio/eio_ttc.c:520:39:    expected void const [noderef] <asn:1>*from
drivers/block/enhanceio/eio_ttc.c:520:39:    got struct cache_list [usertype] *<noident>
drivers/block/enhanceio/eio_ttc.c:550:27: warning: incorrect type in argument 1 (different address spaces)
drivers/block/enhanceio/eio_ttc.c:550:27:    expected void [noderef] <asn:1>*dst
drivers/block/enhanceio/eio_ttc.c:550:27:    got char *<noident>
drivers/block/enhanceio/eio_ttc.c:556:27: warning: incorrect type in argument 1 (different address spaces)
drivers/block/enhanceio/eio_ttc.c:556:27:    expected void [noderef] <asn:1>*dst
drivers/block/enhanceio/eio_ttc.c:556:27:    got struct cache_list [usertype] *<noident>
drivers/block/enhanceio/eio_ttc.c:642:6: warning: symbol 'eio_dec_count' was not declared. Should it be static\
?
drivers/block/enhanceio/eio_ttc.c:663:6: warning: symbol 'eio_endio' was not declared. Should it be static?
drivers/block/enhanceio/eio_ttc.c:675:5: warning: symbol 'eio_dispatch_io_pages' was not declared. Should it b\
e static?
drivers/block/enhanceio/eio_ttc.c:737:5: warning: symbol 'eio_dispatch_io' was not declared. Should it be stat\
ic?
drivers/block/enhanceio/eio_ttc.c:796:5: warning: symbol 'eio_async_io' was not declared. Should it be static?
drivers/block/enhanceio/eio_ttc.c:843:5: warning: symbol 'eio_sync_io' was not declared. Should it be static?
  CC      drivers/block/enhanceio/eio_ttc.o
drivers/block/enhanceio/eio_fifo.c:55:26: warning: symbol 'eio_fifo_ops' was not declared. Should it be static\
?
  CC      drivers/block/enhanceio/eio_fifo.o
  CHECK   drivers/block/enhanceio/eio_lru.c
drivers/block/enhanceio/eio_lru.c:59:16: warning: symbol 'eio_lru' was not declared. Should it be static?
drivers/block/enhanceio/eio_lru.c:67:26: warning: symbol 'eio_lru_ops' was not declared. Should it be static?
  CC      drivers/block/enhanceio/eio_lru.o
  LD      drivers/block/enhanceio/enhanceio.o
