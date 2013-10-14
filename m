Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3JNQRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:17:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:33050 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab3JNQRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,493,1378882800"; 
   d="scan'208";a="410699543"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] libahci: fix turning on LEDs in ahci_start_port()
Thread-Topic: [PATCH] libahci: fix turning on LEDs in ahci_start_port()
Thread-Index: AQHOyOA7gjVotWEo20WnRmchbFX7LZn0XweQ
Date: Mon, 14 Oct 2013 16:15:55 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6639D7@IRSMSX105.ger.corp.intel.com>
References: <20131014125819.19262.32922.stgit@gklab-154-244.igk.intel.com>
 <20131014132049.GB4722@htj.dyndns.org>
In-Reply-To: <20131014132049.GB4722@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 14, 2013 3:21 PM Tejun Heo <tj@kernel.org> wrote:
> On Mon, Oct 14, 2013 at 02:58:19PM +0200, Lukasz Dorau wrote:
> > If EM Transmit bit is busy during init ata_msleep() is called.
> > It is wrong - msleep() should be used instead of ata_msleep(), because
> > if EM Transmit bit is busy for one port, it will be busy for all other
> > ports too, so using ata_msleep() causes wasting tries for another
> > ports.
> >
> > The most common scenario looks like that now (six ports try to
> > transmit a LED meaasege):
> > - port #0 tries for the 1st time and succeeds
> > - ports #1-5 try for the 1st time and sleeps
> > - port #1 tries for the 2nd time and succeeds
> > - ports #2-5 try for the 2nd time and sleeps
> > - port #2 tries for the 3rd time and succeeds
> > - ports #3-5 try for the 3rd time and sleeps
> > - port #3 tries for the 4th time and succeeds
> > - ports #4-5 try for the 4th time and sleeps
> > - port #4 tries for the 5th time and succeeds
> > - port #5 tries for the 5th time and sleeps At this moment port #5
> > wasted all its five tries and failed to initialize.
> > Because there are only 5 (EM_MAX_RETRY) tries available usually only
> > five ports succeed to initialize. The sixth port and next ones usually will fail.
> >
> > If msleep() is used instead of ata_msleep() the first port succeeds to
> > initialize in the first try and next ones usually succeed to initialize in the second
> try.
> 
> Ah, interesting.
> 
> > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> > ---
> >  drivers/ata/libahci.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c index
> > acfd0f7..cf38692 100644
> > --- a/drivers/ata/libahci.c
> > +++ b/drivers/ata/libahci.c
> > @@ -779,7 +779,7 @@ static void ahci_start_port(struct ata_port *ap)
> >  							       emp->led_state,
> >  							       4);
> >  				if (rc == -EBUSY)
> > -					ata_msleep(ap, 1);
> > +					msleep(1);
> 
> This is so unobvious.  Can you please add a comment explaining what's going
> on?
> 

OK, I will send the second version of the patch soon.

Thanks,
Lukasz

