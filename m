Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaCGJig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:38:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60673 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaCGJie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:38:34 -0500
Date: Fri, 7 Mar 2014 10:38:13 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Hui Liu <Hui.Liu@freescale.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: sdio: fix system panic when doing wifi stress
 test
Message-ID: <20140307093813.GA28728@pengutronix.de>
References: <1384221185-8645-1-git-send-email-r64343@freescale.com>
 <87k3fvjvjg.fsf@kamboji.qca.qualcomm.com>
 <AD13664F485EE54694E29A7F9D5BE1AFC0AD96@039-SN2MPN1-022.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AD13664F485EE54694E29A7F9D5BE1AFC0AD96@039-SN2MPN1-022.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:34:58 up 3 days, 21:51,  1 user,  load average: 0,11, 0,50, 1,60
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a61f:72ff:fe69:16d
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Nov 29, 2013 at 06:02:11AM +0000, Hui Liu wrote:
> > -----Original Message-----
> > From: Kalle Valo [mailto:kvalo@qca.qualcomm.com]
> > Sent: Tuesday, November 26, 2013 6:40 PM
> > To: Liu Hui-R64343
> > Cc: linux-arm-kernel@lists.infradead.org; linville@tuxdriver.com; linux-
> > wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; ath6kl-devel@qca.qualcomm.com
> > Subject: Re: [PATCH] ath6kl: sdio: fix system panic when doing wifi
> > stress test
> > 
> > Hi Jason,
> > 
> > Jason Liu <r64343@freescale.com> writes:
> > 
> > > When did the wifi iperf test, meet one following kernel panic:
> > > command: iperf -c $TARGET_IP -i 5 -t 50 -w 1M
> > >
> > > Unable to handle kernel paging request at virtual address 1a480000 pgd
> > > = 80004000 [1a480000] *pgd=00000000 Internal error: Oops: 805 [#1] SMP
> > > ARM
> > 
> > [...]
> > 
> > > The kernel panic is caused by the sg_buf is not set correctly with the
> > > following code when compiled with Yocto GCC 4.8.1:
> > >
> > > drivers/net/wireless/ath/ath6kl/hif.h:
> > > struct hif_scatter_req {
> > >         struct list_head list;
> > >         /* address for the read/write operation */
> > >         u32 addr;
> > > 	...
> > >
> > >         /* bounce buffer for upper layers to copy to/from */
> > >         u8 *virt_dma_buf;
> > >
> > >         struct hif_scatter_item scat_list[1];
> > >
> > >         u32 scat_q_depth;
> > > };
> > >
> > > (Note: the scat_req.scat_list[] will dynamiclly grow with run-time)
> > 
> > There's actually a major bug right there, scat_list can corrupt
> > scat_q_depth.
> > 
> > > The GCC 4.8.1 compiler will not do the for-loop till scat_entries,
> > > instead, it only run one round loop. This may be caused by that the
> > > GCC 4.8.1 thought that the scat_list only have one item and then no
> > > need to do full iteration, but this is simply wrong by looking at the
> > > assebly code. This will cause the sg buffer not get set when
> > scat_entries > 1 and thus lead to kernel panic.
> > >
> > > This patch is a workaround to the GCC 4.8.1 complier issue by passing
> > > the entry address of the scat_req->scat_list to the for-loop and
> > > interate it, then, GCC 4.8.1 will do the full for-loop correctly.
> > > (Note: This issue not observed with GCC 4.7.2, only found on the GCC
> > > 4.8.1)
> > >
> > > This patch does not change any function logic and no any performance
> > downgrade.
> > 
> > [...]
> > 
> > > +	scat_list = &scat_req->scat_list[0];
> > > +
> > >  	/* assemble SG list */
> > > -	for (i = 0; i < scat_req->scat_entries; i++, sg++) {
> > > +	for (i = 0; i < scat_req->scat_entries; i++, sg++, scat_list++) {
> > >  		ath6kl_dbg(ATH6KL_DBG_SCATTER, "%d: addr:0x%p, len:%d\n",
> > > -			   i, scat_req->scat_list[i].buf,
> > > -			   scat_req->scat_list[i].len);
> > > +			   i, scat_list->buf, scat_list->len);
> > >
> > > -		sg_set_buf(sg, scat_req->scat_list[i].buf,
> > > -			   scat_req->scat_list[i].len);
> > > +		sg_set_buf(sg, scat_list->buf, scat_list->len);
> > >  	}
> > 
> > Working around the problem by adding a temporary variable makes me a bit
> > worried, I would rather fix the root cause. Is the root cause by that we
> > define the field with scat_list[1]?
> 
> Yes, this is what I assumed. 
> 
> > 
> > Does the patch below help? It would also fix the corruption with
> > scat_q_depth. Please note that I have only compile tested it. And I might
> > have also missed something important, so please review it carefully.
> 
> Yes, Firstly, I have looked at the asm code and the compiler(gcc 4.8.1) works correctly after applying
> the following patch. Secondly, I have tested the patch with compiler(gcc 4.8.1) on the real HW, and it
> works fine too. Without the patch, the kernel crash will happen 100%.
> 
> Thus, for the patch:
> 
> Acked-by: Jason Liu <r64343@freescale.com>
> Tested-by: Jason Liu <r64343@freescale.com>
> 
> Jason Liu
> 
> > 
> > --- a/drivers/net/wireless/ath/ath6kl/hif.h
> > +++ b/drivers/net/wireless/ath/ath6kl/hif.h
> > @@ -197,9 +197,9 @@ struct hif_scatter_req {
> >  	/* bounce buffer for upper layers to copy to/from */
> >  	u8 *virt_dma_buf;
> > 
> > -	struct hif_scatter_item scat_list[1];
> > -
> >  	u32 scat_q_depth;
> > +
> > +	struct hif_scatter_item scat_list[0];
> >  };
> > 
> >  struct ath6kl_irq_proc_registers {
> > diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c
> > b/drivers/net/wireless/ath/ath6kl/sdio.c
> > index 7126bdd..6bf15a3 100644
> > --- a/drivers/net/wireless/ath/ath6kl/sdio.c
> > +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
> > @@ -348,7 +348,7 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct
> > ath6kl_sdio *ar_sdio,
> >  	int i, scat_req_sz, scat_list_sz, size;
> >  	u8 *virt_buf;
> > 
> > -	scat_list_sz = (n_scat_entry - 1) * sizeof(struct hif_scatter_item);
> > +	scat_list_sz = n_scat_entry * sizeof(struct hif_scatter_item);
> >  	scat_req_sz = sizeof(*s_req) + scat_list_sz;
> > 
> >  	if (!virt_scat)
> > 
> > 
> > --
> > Kalle Valo
> 

What happend with this?
If I look in mainline, I don't find it. At least the reording of the struct
fields looks as if one definitely wants to have that.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
