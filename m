Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3CUTLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:11:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3CUTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:11:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] USB: EHCI: fix for leaking isochronous data
Date: Thu, 21 Mar 2013 19:10:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Soeren Moch <smoch@web.de>, Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-mm@kvack.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, michael@amarulasolutions.com
References: <Pine.LNX.4.44L0.1303171320560.26486-100000@netrider.rowland.org> <514B3DBB.3060302@web.de> <20130321173324.GY13280@titan.lakedaemon.net>
In-Reply-To: <20130321173324.GY13280@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303211910.31473.arnd@arndb.de>
X-Provags-ID: V02:K0:ygqnK0FUPxv9H6awUPb1LdKid1YYqiV6RDFuTU3P91W
 cw05nh0ISknUh/pYuNVPDW7XrYnbNSTqtCyx2gkuobk5yzSxsD
 R2kSvVLdk7oLDfuuUSEKdWO6JnOZQvUmNCBzj+ZYxlstcIg8ye
 ZDP2utbKFwHcctYnxRmf8qLZSEc1HoQZb47UiNfVQvE0h22FVX
 1ywPQwm4lNH0egD4g1k4PknCvGzf2LcnCtHGjr17X3MyF8kWnU
 cLfTCyCaO4TuX+iWgX/fqLI3oIBa0/TQRB474knyD20tyoCoy+
 0dHuT93MIqK1W45uBo17PB1/OKi6mmRFycRb3uZcQiHA8OdyJi
 HHzxVsCEUqetL4tPd8SM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 March 2013, Jason Cooper wrote:
> On Thu, Mar 21, 2013 at 06:04:59PM +0100, Soeren Moch wrote:

> > 
> > Now I found out what is going on here:
> > 
> > In itd_urb_transaction() we allocate 9 iTDs for each URB with
> > number_of_packets == 64 in my case. The iTDs are added to
> > sched->td_list. For a frame-aligned scheduling we need 8 iTDs, the
> > 9th one is released back to the front of the streams free_list in
> > iso_sched_free(). This iTD was cleared after allocation and has a
> > frame number of 0 now. So for each allocation when now_frame == 0 we
> > allocate from the dma_pool, not from the free_list. The attached
> > patch invalidates the frame number in each iTD before it is sent to
> > the scheduler. This fixes the problem without the need to iterate
> > over a iTD list.
> > 
> > Signed-off-by: Soeren Moch <smoch@web.de>
> 
> Wow!  Great work Soeren!  Talk about a long road to a small fix.  Thanks
> for keeping after it.

+1

I hardly understand half of the description above, but that much sounds
plausible. Is this a bug fix that should get backported to stable kernels?

	Arnd
