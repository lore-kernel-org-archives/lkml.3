Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaEUSOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:14:44 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61875 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaEUSOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:14:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@kernel.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, s-anna@ti.com, loic.pallardy@st.com,
        lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, robherring2@gmail.com,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
Date: Wed, 21 May 2014 20:14:36 +0200
Message-ID: <5277579.yApJqY0s9l@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140521172701.GV12304@sirena.org.uk>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org> <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org> <20140521172701.GV12304@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lTzIIUU49oviosgI0nKQoPuurt6DtQY5gbcgs0bWpUp
 pwl8lzfthVfiOYCM40A328gUMr4uu4vXEjneTLs4djZOEVNBFb
 rrRvAgZv7kElJUAL5WaIP+QXk5MvRDmqitn66NL1z37fFrMnzv
 8TwRBDfAYynDx+kYbrO/5rcdIG4uXwokrmkXnyw18abBBnw1u7
 Jiej7w2JvLL7QHTIACb9/dSAFFlgn2soica9aNyOKUDkzeutTu
 0OGyTSpwxp6iUqL9DvUGUIFVgwbgBWiCv+C1YQif8efzmRS+h+
 Xlhh24p81wtvwJi98mbvE6G60cyQ8DzSSY2fHnUzCXncPyJh4F
 k7gbHm++rls54yjihhBI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 18:27:01 Mark Brown wrote:
> > +     /* The queued TX requests are simply aborted, no callbacks are made */
> > +     spin_lock_irqsave(&chan->lock, flags);
> > +     chan->cl = NULL;
> > +     chan->active_req = NULL;
> > +     if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
> > +             chan->txdone_method = TXDONE_BY_POLL;
> > +
> > +     module_put(chan->mbox->dev->driver->owner);
> > +     spin_unlock_irqrestore(&chan->lock, flags);
> 
> Is the module_put() safe in atomic context?
> 

I'm pretty sure it is:

void module_put(struct module *module)
{
        if (module) {
                preempt_disable();
                smp_wmb(); /* see comment in module_refcount */
                __this_cpu_inc(module->refptr->decs);

                trace_module_put(module, _RET_IP_);
                preempt_enable();
        }
}

This disables preemption around everything it does, so everything inside
is definitely safe in nonpreemptible context.

	Arnd
