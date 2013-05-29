Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967194Ab3E2XSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:18:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42467 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967185Ab3E2XRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:17:48 -0400
Message-ID: <1369869467.22004.122.camel@joe-AO722>
Subject: Re: [PATCH] timer: Fix jiffies wrap behavior of round_jiffies*()
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 29 May 2013 16:17:47 -0700
In-Reply-To: <20130529160150.f0a498d188dc790d018200e9@linux-foundation.org>
References: <519BC066.5080600@acm.org>
	 <20130529160150.f0a498d188dc790d018200e9@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 16:01 -0700, Andrew Morton wrote:
> On Tue, 21 May 2013 20:43:50 +0200 Bart Van Assche <bart.vanassche@gmail.com> wrote:
> 
> > Make sure that the round_jiffies*() functions return a time that is
> > in the future when the jiffies counter is about to wrap.
> 
> Actually "when the jiffies counter has recently wrapped".
> 
> I assume this was found by inspection?
> 
> > @@ -149,9 +149,7 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
> >  	/* now that we have rounded, subtract the extra skew again */
> >  	j -= cpu * 3;
> > -	if (j <= jiffies) /* rounding ate our timeout entirely; */
> 
> This used to be a very common bug - we've weeded out many instances but
> I'm sure more still remain.

This list probably isn't comprehensive.

$ git grep -E "if\s*\((\s*jiffies\s*[\<\>]|.*[\<\>]=?\s*jiffies\b)"
drivers/acpi/acpi_pad.c:                if (last_jiffies + round_robin_time * HZ < jiffies) {
drivers/acpi/acpi_pad.c:                        if (jiffies > expire_time) {
drivers/dma/ioat/dma_v2.c:      if (jiffies > chan->timer.expires && timer_pending(&chan->timer)) {
drivers/infiniband/hw/ipath/ipath_sdma.c:               if (jiffies < dd->ipath_sdma_abort_intr_timeout)
drivers/infiniband/hw/ipath/ipath_sdma.c:       if (jiffies > dd->ipath_sdma_abort_jiffies) {
drivers/infiniband/ulp/ipoib/ipoib_cm.c:                if (p && time_after_eq(jiffies, p->jiffies + IPOIB_CM_RX_UPDATE
drivers/infiniband/ulp/ipoib/ipoib_cm.c:                if (time_before_eq(jiffies, p->jiffies + IPOIB_CM_RX_TIMEOUT))
drivers/input/misc/ati_remote2.c:               if (!time_after_eq(jiffies, ar2->jiffies))
drivers/md/dm-log-userspace-base.c:     else if (jiffies < limit)
drivers/misc/sgi-gru/grumain.c:                 if (gts->ts_steal_jiffies + GRU_STEAL_DELAY < jiffies)
drivers/net/ethernet/intel/e1000/e1000_ethtool.c:               if (jiffies >= (time + 2)) {
drivers/net/ethernet/intel/e1000e/ethtool.c:            if (jiffies >= (time + 20)) {
drivers/net/ethernet/micrel/ksz884x.c:                  if (next_jiffies < jiffies)
drivers/net/ethernet/micrel/ksz884x.c:          } else if (jiffies >= hw_priv->counter[i].time) {
drivers/net/ethernet/micrel/ksz884x.c:          if (hw_priv->pme_wait <= jiffies) {
drivers/net/ethernet/neterion/vxge/vxge-main.c: if (jiffies > fifo->jiffies + HZ / 100) {
drivers/net/ethernet/neterion/vxge/vxge-main.c: if (jiffies > ring->jiffies + HZ / 100) {
drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c:                 if (jiffies > (QLCNIC_FILTER_AGE * HZ + time)) {
drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c:                 if (jiffies > (QLCNIC_FILTER_AGE * HZ + time)) {
drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:                         if (jiffies > (QLCNIC_READD_AGE * HZ + time))
drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:                 if (jiffies > (QLCNIC_READD_AGE * HZ + tmp_fil->ftime))
drivers/scsi/lpfc/lpfc_scsi.c:  if ((phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL) > jiffies) {
drivers/staging/bcm/InterfaceIdleMode.c:                if (timeout < jiffies )
drivers/staging/lustre/include/linux/libcfs/linux/linux-prim.h:                 if (jiffies > expire) {           \
drivers/staging/speakup/speakup_acntpc.c:               if (jiffies >= jiff_max && ch == SPACE) {
drivers/staging/speakup/speakup_decext.c:                       if (jiffies >= jiff_max) {
drivers/staging/speakup/speakup_decpc.c:                        if (jiffies >= jiff_max) {
drivers/staging/speakup/speakup_dectlk.c:                       if (jiffies >= jiff_max) {
kernel/timer.c: if (j <= jiffies) /* rounding ate our timeout entirely; */
net/rds/ib_send.c:                      if (ic->i_ack_queued + HZ/2 < jiffies)
net/rds/ib_send.c:                      if (send->s_queued + HZ/2 < jiffies)
net/rds/iw_send.c:                      if (ic->i_ack_queued + HZ/2 < jiffies)
net/rds/iw_send.c:                      if (send->s_queued + HZ/2 < jiffies)

>   We could perhaps have a checkpatch rule
> which looks for comparisons against jiffes (and any other
> time-measuring variables we can detect)

other variables like?

>  and tells people to use
> time_after() and friends, or time_is_*_jiffies().


