Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946861Ab3BHRiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:38:13 -0500
Received: from tetsuo.zabbo.net ([50.193.208.193]:38327 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946765Ab3BHRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:38:12 -0500
Date: Fri, 8 Feb 2013 09:38:11 -0800
From: Zach Brown <zab@zabbo.net>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        koverstreet@google.com, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Improving AIO cancellation
Message-ID: <20130208173811.GW14246@lenny.home.zabbo.net>
References: <CAOMFOmXiEUnqkoQg6bA4N3jg5ERMKoydOdmn7djkpFyfZk19cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMFOmXiEUnqkoQg6bA4N3jg5ERMKoydOdmn7djkpFyfZk19cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The draft implementation will look like this. struct bio should have
> some way to get current status of kiocb that generated bio. So we add
> a pointer to bool flag.
> 
> struct bio {
>   bool *cancelled;
> }
> 
> in async DIO codepath this pointer will be initialized with bool at
> "struct kiocb"
>   bio->cancelled = &kiocb->cancelled;

Hmm.  I suppose.  It sure looks disgusting, but the iocb has forgotten
all of the dio state and bios that lead up to the operation once
submission has completed.  It's easy enough to match the lifetime rules
of this reference with end_io's using the iocb.

This method also lets one cancelled iocb flag many submitted bios as
cancelled, so that's nice.

> So to cancel kiocb we do
> kiocb->cancelled = true;
> and all bio created from the request will not be send to device anymore.

(With lots of comments to let us know that it being racey is fine.)

> If the proposal is fine then I start implementing it.

For a teeny hack like this the best proposal is a working prototype
patch.  Don't wait for acks just dive in.

- z
