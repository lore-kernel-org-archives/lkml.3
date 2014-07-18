Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbaGRVny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:43:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38058 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbaGRVnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:43:53 -0400
Message-Id: <1405719831.23447.143252001.73A15F1B@webmail.messagingengine.com>
X-Sasl-Enc: uub+x97JekU7ffeM4eRkfeWYprzQu9IN5w73R3raHRqw 1405719831
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Price <price@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-95f8bb3a
Subject: Re: [PATCH] random: check for increase of entropy_count because of
 signed conversion
Date: Fri, 18 Jul 2014 23:43:51 +0200
In-Reply-To: <20140718212504.GC18775@thunk.org>
References: <20140716083308.GF1491@thunk.org>
 <442eeebeb78f9f2d4066ad923f4144fc2110c6f7.1405538086.git.hannes@stressinduktion.org>
 <20140718212504.GC18775@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 18, 2014, at 23:25, Theodore Ts'o wrote:
> On Wed, Jul 16, 2014 at 09:18:15PM +0200, Hannes Frederic Sowa wrote:
> > The expression entropy_count -= ibytes << (ENTROPY_SHIFT + 3) could
> > actually increase entropy_count if during assignment of the unsigned
> > expression on the RHS (mind the -=) we reduce the value modulo
> > 2^width(int) and assign it to entropy_count. Trinity found this.
> > 
> > Reported-by: Dave Jones <davej@redhat.com>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Cc: Greg Price <price@mit.edu>
> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > ---
> > As indicated by credit_entropy_bits entropy_count cannot get negative,
> > so I don't see any reason to include a check for entropy_count < 0
> > here. Do you agree?
> 
> No, the check is important; after we subtract ibytes << (ENTROPY_SHIFT
> + 3) we could drive entropy_count negative, and we don't want to
> trigger the WARN_ON().

If we always enter account() with r->entropy_count > 0 I think the
checks in place after this patch should suffice. The problem should only
arise in case entropy_count < 0 at the beginning of account (or in
between if we need to do a retry).

I didn't find a way how entropy_count could get smaller than 0 without
hitting a WARN_ON and a reset of r->entropy_count = 0.

Thanks,
Hannes
