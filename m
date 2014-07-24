Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbaGXUfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:35:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59923 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:35:04 -0400
Date: Thu, 24 Jul 2014 21:34:36 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org, linux@openrisc.net, jonas@southpole.se
Subject: Re: [PATCH 1/6] openrisc: add Kconfig for l.lwa and l.swa atomic
 instructions
Message-ID: <20140724213436.511e08ad@alan.etchedpixels.co.uk>
In-Reply-To: <20140724195237.GA12313@chokladfabriken.org>
References: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
	<1406150296-13308-2-git-send-email-stefan.kristiansson@saunalahti.fi>
	<20140723222601.51a8b788@alan.etchedpixels.co.uk>
	<20140724195237.GA12313@chokladfabriken.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wasn't familiar with the alternatives logic before, so I had
> to look it up.
> Correct me if I'm wrong, but from what I gathered, the approach
> that takes is especially suitable to fixup instructions that
> are similar to each others but have slightly different properties
> (the lock prefix to cmpxchg being the canonical example).

You need some similarity or in some cases it makes sense to swap the
instruction with a call to a helper out of line, rather than taking the
hit on the traps and emulation.

> I guess it'd be *possible* to still use this method to implement
> alternatives that would work in the UP case by disabling
> context-switch and perform normal loads and stores in place
> of the l.lwa and l.swa instructions, but is it really a good approach?

We actually did that on the 386 when it was still supported as 386
lacked some of the more obscure atomic instructions. Some other platforms
use constructs of the form

       do {
	i = reschedule_count
	do repeatable ops
        }
	while(reschedule_count != i)

for non irq safe locking ops rather than irq off/on. Another approach is
to use a section to gather all the out of line "atomic" operations - ie
all the helpers - and not reschedule if the return address is in the
"atomic" section.

Most of the other architectures we ask these questions and generate code
for "at least this feature set" but then also hide the detail, although I
imagine most openrisc users are smarter than the average.

Alan
