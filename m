Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3CXQCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 12:02:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54288 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab3CXQCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 12:02:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Mar 2013 17:02:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Vijay <thelonejoker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Workqueue behaviour - Synchronization within submitted work.
Message-ID: <20130324170234.0eeb1fe9@stein>
In-Reply-To: <CAEtk5ge3MBn5759EfUVdNRmb2g=kvtbe7u+xkZXy5E0KoynoJw@mail.gmail.com>
References: <CAEtk5ge3MBn5759EfUVdNRmb2g=kvtbe7u+xkZXy5E0KoynoJw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 20 Vijay wrote:
> In the new workqueue architecture, I have a question regarding
> synchronization between different "work" submitted to the same
> workqueue. For example:
> 
> * I submit two "works" A and B to a common driver specific workqueue (W).
> * Each A and B, meddle with a certain shared data SD.
> * Am I guaranteed serialized execution of A and B, or should I play
> safe and use a semaphore (acquire/release) with A and B ?

The works A and B may be (and more or less likely will be) executed in
parallel --- except if you create the workqueue with parameters @flags |=
WQ_UNBOUND and @max_active = 1.  alloc_ordered_workqueue() is a shorthand
for creation of such a workqueue.

Some more thoughts:
  - If you go for an ordered workqueue and no other means of serialization
    of accesses to your data, check carefully that these data are indeed
    never accessed in other contexts besides the workers.
  - For serialization in non-atomic context, a struct mutex is usually
    preferred over a struct semaphore.  The foremost advantage of mutexes
    over counting semaphores is that code using the former can be debugged
    much easier.
-- 
Stefan Richter
-=====-===-= --== ==---
http://arcgraph.de/sr/
