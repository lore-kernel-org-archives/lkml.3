Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaFMNnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:43:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34027 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752386AbaFMNnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:43:01 -0400
Date: Fri, 13 Jun 2014 09:43:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Wei.Yang@windriver.com, <balbi@ti.com>, <andrzej.p@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <xa1td2ednnxo.fsf@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1406130939540.1059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Michal Nazarewicz wrote:

> > The root cause is that the existing code fails to take into
> > account the possibility that common->new_fsg can change while
> > do_set_interface() is running, because the spinlock isn't held
> > at this point.
> 
> common->new_fsg is not protected by common->lock so this justification
> is not valid.

That's true.  A better justification would be that the same value of 
new_fsg should be used in do_set_interface() and in the test that 
follows.

> > @@ -2421,6 +2422,7 @@ static void handle_exception(struct fsg_common *common)
> >  		}
> >  		common->state = FSG_STATE_IDLE;
> >  	}
> > +	new_fsg = common->new_fsg;
> 
> Also, because common->new_fsg is not protected by common->lock, doing
> this under a lock is kinda pointless.

Yes, but it doesn't hurt.

> >  	spin_unlock_irq(&common->lock);
> >  
> >  	/* Carry out any extra actions required for the exception */
> > @@ -2460,8 +2462,8 @@ static void handle_exception(struct fsg_common *common)
> >  		break;
> >  
> >  	case FSG_STATE_CONFIG_CHANGE:
> > -		do_set_interface(common, common->new_fsg);
> > -		if (common->new_fsg)
> > +		do_set_interface(common, new_fsg);
> > +		if (new_fsg)
> >  			usb_composite_setup_continue(common->cdev);
> 
> As far as I can tell, it's safe to move the assignment to new_fsg here,
> e.g.:
> 
> 		new_fsg = common->new_fsg;
> 		do_set_interface(common, new_fsg);
> 		if (new_fsg)
> 			usb_composite_setup_continue(common->cdev);

That would be equally correct.  I don't see any strong reason for 
preferring one over the other.

> >  		break;
> 
> But perhaps new_fsg should be protected by the lock.  I think valid fix
> (which I did not test in *any* way) will be this:

No, I think this change is both too big and unnecessary.  
common->new_fsg does not need protection; in a sense it is "owned" by 
the composite driver.

Alan Stern

