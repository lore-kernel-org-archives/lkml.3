Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbaEYR3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 13:29:50 -0400
Received: from mout.gmx.net ([212.227.17.20]:61477 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaEYR3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 13:29:49 -0400
Message-ID: <1401038979.7538.6.camel@schoellingm.dzne.de>
Subject: Re: [PATCH] ipath: use time_before()/_after()
From: Manuel Schoelling <manuel.schoelling@gmx.de>
To: Dongsheng Yang <dongsheng081251@gmail.com>
Cc: infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 25 May 2014 19:29:39 +0200
In-Reply-To: <CA+qeAOqUQ07YpFJjvFstUCDzt6-P_zBz-O1==OOYeBVOJ8Gppw@mail.gmail.com>
References: <1401024401-1992-1-git-send-email-manuel.schoelling@gmx.de>
	 <CA+qeAOqUQ07YpFJjvFstUCDzt6-P_zBz-O1==OOYeBVOJ8Gppw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:4IYR77Gbt9nHYt859C8EYuLiCV6OeO8oovCEyemcnQXxEslJPvQ
 LTb0dkUo0uTWKXgkZlipqSmYa0u09v+/eBeNhggDr9hipMoN1508LlE05MHcngKj1WGnqju
 ikURsTox3zZJphU+08DwLmnREIPS+6jSKjZP6uf9OJH31FqGgOqQkNRtyqteOOZghLCgP3w
 oRl+qPRxbm0qypj8/CgJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, 2014-05-25 at 22:17 +0800, Dongsheng Yang wrote:
> On Sun, May 25, 2014 at 9:26 PM, Manuel Schölling
> <manuel.schoelling@gmx.de> wrote:
> > To be future-proof and for better readability the time comparisons are
> > modified to use time_before/_after() instead of plain, error-prone math.
> >
> > Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> > ---
> >  drivers/infiniband/hw/ipath/ipath_intr.c |    4 ++--
> >  drivers/infiniband/hw/ipath/ipath_sdma.c |    4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
> > index 26dfbc8..01ba792 100644
> > --- a/drivers/infiniband/hw/ipath/ipath_intr.c
> > +++ b/drivers/infiniband/hw/ipath/ipath_intr.c
> > @@ -70,7 +70,7 @@ void ipath_disarm_senderrbufs(struct ipath_devdata *dd)
> >         if (sbuf[0] || sbuf[1] || (piobcnt > 128 && (sbuf[2] || sbuf[3]))) {
> >                 int i;
> >                 if (ipath_debug & (__IPATH_PKTDBG|__IPATH_DBG) &&
> > -                       dd->ipath_lastcancel > jiffies) {
> > +                       time_after(dd->ipath_lastcancel, jiffies)) {
> 
> Why not time_is_after_jiffies()?
According to Joe Perches [1], time_after() is used much more often than
time_is_after_jiffies() and should be preferred.

[1] http://www.spinics.net/lists/netdev/msg283219.html

> 
> >                         __IPATH_DBG_WHICH(__IPATH_PKTDBG|__IPATH_DBG,
> >                                           "SendbufErrs %lx %lx", sbuf[0],
> >                                           sbuf[1]);
> > @@ -755,7 +755,7 @@ static int handle_errors(struct ipath_devdata *dd, ipath_err_t errs)
> >
> >         /* likely due to cancel; so suppress message unless verbose */
> >         if ((errs & (INFINIPATH_E_SPKTLEN | INFINIPATH_E_SPIOARMLAUNCH)) &&
> > -               dd->ipath_lastcancel > jiffies) {
> > +               time_after(dd->ipath_lastcancel, jiffies)) {
> >                 /* armlaunch takes precedence; it often causes both. */
> >                 ipath_cdbg(VERBOSE,
> >                         "Suppressed %s error (%llx) after sendbuf cancel\n",
> > diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/infiniband/hw/ipath/ipath_sdma.c
> > index 98ac18e..17a5177 100644
> > --- a/drivers/infiniband/hw/ipath/ipath_sdma.c
> > +++ b/drivers/infiniband/hw/ipath/ipath_sdma.c
> > @@ -247,7 +247,7 @@ static void sdma_abort_task(unsigned long opaque)
> >
> >         /* ipath_sdma_abort() is done, waiting for interrupt */
> >         if (status == IPATH_SDMA_ABORT_DISARMED) {
> > -               if (jiffies < dd->ipath_sdma_abort_intr_timeout)
> > +               if (time_before(jiffies, dd->ipath_sdma_abort_intr_timeout))
> >                         goto resched_noprint;
> >                 /* give up, intr got lost somewhere */
> >                 ipath_dbg("give up waiting for SDMADISABLED intr\n");
> > @@ -341,7 +341,7 @@ resched:
> >          * JAG - this is bad to just have default be a loop without
> >          * state change
> >          */
> > -       if (jiffies > dd->ipath_sdma_abort_jiffies) {
> > +       if (time_after(jiffies, dd->ipath_sdma_abort_jiffies)) {
> >                 ipath_dbg("looping with status 0x%08lx\n",
> >                           dd->ipath_sdma_status);
> >                 dd->ipath_sdma_abort_jiffies = jiffies + 5 * HZ;
> > --
> > 1.7.10.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


