Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878Ab3DOVSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:18:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab3DOVSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:18:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH/RFC 3/6] DMA: shdma: add DT support
Date: Mon, 15 Apr 2013 23:18:42 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de> <1365632389-2249-4-git-send-email-g.liakhovetski@gmx.de> <20130415164238.GG12436@intel.com>
In-Reply-To: <20130415164238.GG12436@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304152318.42913.arnd@arndb.de>
X-Provags-ID: V02:K0:/hXNVHoV74LTekovMSIKZ++k8gKJrrzbx928VnVHV2j
 wxckD/C1dWsvGL4S0woidJIHMcMSFOFm1lCu9VQgbGi+a3BS/y
 afBq1bGJVwm1lx8aBOqSPqPMwaNjSI2VrkmMVm3IQ4bzN7bXu7
 gpawaFYr0x0pRmMaL+BjzrgH+6dE3nyG/fKFgmMAsBXaCzI+ri
 6xo+JWivVTr2QmWh5zaqnaAcGgZCQILNZNhUtSit2rqXmiLWoH
 agLznmPtJ9iRuybNDh414aYyN0nX64FwVEEWpMz2bVKQimexj2
 qalG0uiFXJeC3tfrXbXhIKx0qSZOggbQ3RdqUlBUHcTpALQhKF
 LbALOZsBiTo41DdeFL+0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 April 2013, Vinod Koul wrote:
> On Thu, Apr 11, 2013 at 12:19:46AM +0200, Guennadi Liakhovetski wrote:
> > This patch adds Device Tree support to the shdma driver. No special DT
> > properties are used, only standard DMA DT bindings are implemented. Since
> > shdma controllers reside on SoCs, their configuration is SoC-specific and
> > shall be passed to the driver from the SoC platform data, using the
> > auxdata procedure.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > ---
> Need Arnd to review :)

This patch is missing the DT binding document, which is necessary for a proper
review, and as a documentation for anyone trying to write device tree source
files.

In particular, it is not clear what mid/rid refer to here and whether they should
be represented as one or two cells. The driver here uses one cell, which is probably
ok, but I'd like to understand that anyway.

> > + * NOTE 2: This filter function is also used in the DT case by shdma_xlate().
> > + * In that case the MID-RID value is used for slave channel filtering and is
> > + * passed to this function in the "arg" parameter.
> >   */
> >  bool shdma_chan_filter(struct dma_chan *chan, void *arg)
> >  {
> >  	struct shdma_chan *schan = to_shdma_chan(chan);
> >  	struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
> >  	const struct shdma_ops *ops = sdev->ops;
> > -	int slave_id = (int)arg;
> > +	int match = (int)arg;
> >  	int ret;
> >  
> > -	if (slave_id < 0)
> > +	if (match < 0)
> >  		/* No slave requested - arbitrary channel */
> >  		return true;
> >  
> > -	if (slave_id >= slave_num)
> > +	if (!schan->dev->of_node && match >= slave_num)
> >  		return false;
> >  
> > -	ret = ops->set_slave(schan, slave_id, true);
> > +	ret = ops->set_slave(schan, match, true);
> >  	if (ret < 0)
> >  		return false;

The filter function should really ensure that the dma_chan.device matches
the device passed as the argument before accessing any members of
the outer structures. This seems to be a preexisting bug.

> > +struct dma_chan *shdma_xlate(struct of_phandle_args *dma_spec,
> > +				 struct of_dma *ofdma)
> > +{
> > +	struct shdma_dev *sdev = ofdma->of_dma_data;
> > +	u32 id = dma_spec->args[0];
> > +	dma_cap_mask_t mask;
> > +	struct dma_chan *chan;
> > +
> > +	if (dma_spec->args_count != 1 || !sdev)
> > +		return NULL;
> > +
> > +	dma_cap_zero(mask);
> > +	/* Only slave DMA channels can be allocated via DT */
> > +	dma_cap_set(DMA_SLAVE, mask);
> > +
> > +	chan = dma_request_channel(mask, shdma_chan_filter, (void *)id);
> > +	if (chan)
> > +		to_shdma_chan(chan)->hw_req = id;
> > +
> > +	return chan;
> > +}
> > +EXPORT_SYMBOL(shdma_xlate);

And consequently, this function should pass the sdev into the filter function
along with the id.

With a binding document added, the patch seems ok. The check for the device should
probably be added to the filter function in any case.


	Arnd
