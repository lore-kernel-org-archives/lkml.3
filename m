Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3CBKNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 05:13:34 -0500
Received: from mail.gnuher.de ([78.47.12.54]:38442 "EHLO mail.gnuher.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3CBKNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 05:13:33 -0500
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Mar 2013 05:13:33 EST
Date: Sat, 2 Mar 2013 10:45:10 +0100
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: Marcin Jurkowski <marcin1j@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: reproducible w1 oops on recent kernels (at least since 3.2.x)
Message-ID: <20130302094510.GA4695@geggus.net>
References: <20130116141627.GA23638@ioremap.net>
 <20130302001103.GB18026@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130302001103.GB18026@gmail.com>
X-MimeOLE: Produced By Exchange Microsoft V6.6.6
User-Agent: Mutt/1.5.21 (2010-09-15)
X-remote-host: diesel.geggus.net [2a01:198:297:1:21c:c0ff:fefa:8a7b]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Jurkowski schrieb am Samstag, den 02. März um 01:11 Uhr:

> I can confirm that this bug persists in recent kernel. Onewire netlink
> interface to W1_SEARCH command must have been broken for a while.
> 
> Good news is that it seems to be easy to fix. I'll post an explanation 
> and a patch tomorrow.

I did not send this to the kernel Mailinglist but to Evgeniy
only. This is the bad commit I found doing git bisect:

04f482faf50535229a5a5c8d629cf963899f857c is the first bad commit
commit 04f482faf50535229a5a5c8d629cf963899f857c
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Mar 28 08:39:36 2011 +0000
                                      
    connector: convert to synchronous netlink message processing
                                                                
    Commits 01a16b21 (netlink: kill eff_cap from structnetlink_skb_parms)
    and c53fa1ed (netlink: kill loginuid/sessionid/sid members fromstruct
    netlink_skb_parms) removed some members from structnetlink_skb_parms 
    that depend on the current context, all netlink users are nowrequired
    to do synchronous message processing.                                 
                                         
    connector however queues received messages and processes them ina work
    queue, which is not valid anymore. This patch converts connectorto do 
    synchronous message processing by invoking the registeredcallback    
    handler directly from the netlink receive function.               
                                                       
    In order to avoid invoking the callback with connector locksheld, a
    reference count is added to struct cn_callback_entry, thereference 
    is taken when finding a matching callback entry on the device'squeue_list
    and released after the callback handler has been invoked.                 
                                                             
    Signed-off-by: Patrick McHardy <kaber@trash.net>         
    Acked-by: Evgeniy Polyakov <zbr@ioremap.net>    
    Signed-off-by: David S. Miller <davem@davemloft.net>

Sven

-- 
"C Is Quirky, Flawed, And An Enormous Success."
(Dennis M. Ritchie)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web
