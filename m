Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbbAWBaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:30:19 -0500
Received: from leo.clearchain.com ([199.73.29.74]:31089 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbAWBaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:30:14 -0500
Date: Fri, 23 Jan 2015 11:30:00 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: MT - Add support for balanced slot assignment
Message-ID: <20150123013000.GA23706@jelly.redhat.com>
References: <1421956345-1546-1-git-send-email-rydberg@bitmath.org>
 <20150122200252.GE18153@dtor-ws>
 <54C15C61.9000100@bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C15C61.9000100@bitmath.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (mail.clearchain.com [127.0.0.1]); Fri, 23 Jan 2015 12:00:05 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 09:24:01PM +0100, Henrik Rydberg wrote:
> Hi Dmitry,
> 
> On 01/22/2015 09:02 PM, Dmitry Torokhov wrote:
> > On Thu, Jan 22, 2015 at 08:52:25PM +0100, Henrik Rydberg wrote:
> >>  int input_mt_assign_slots(struct input_dev *dev, int *slots,
> >> -			  const struct input_mt_pos *pos, int num_pos)
> >> +			  const struct input_mt_pos *pos, int num_pos,
> >> +			  int dmax)
> > 
> > Should dmax be unsigned and do we really need to treat 0 specially or we
> > could use UNIT_MAX as "don't care" value?
> 
> We could have dmax unsigned, but it does not have to be from a branching
> perspective, since the square is what gets used anyways.
> 
> >>  {
> >>  	struct input_mt *mt = dev->mt;
> >> +	int mu = 2 * dmax * dmax;
> > 
> > For my education, what does "mu" stand for?
> 
> I chose mu because of the mathematical similarity to the chemical potential in
> statistical mechanics, where it denotes the energy per particle. Here, it
> denotes the energy per contact assignment.

can we please choose something that doesn't require the reviewer to have
familarity of statistical mechanics to make sense of a variable in the
multitouch tracking code?
 
> > Ideally, if someone could create a
> > write-up on the contact matching that would be most awesome.
> 
> Heh, I guess I will have to write something at some point, without requiring
> prior knowledge of Lagrange relaxation or the like. Time is a luxury these days...

yes please. the current code is pretty much inpenetrable for me.
for all I know it's sending a postcard to santa. judging by Benjamin's
comment "can someone tell what this function actually does" comment in the
doc patchset I'm not the only one.

this link here seems to explain the algorithm for mere mortals
http://www.troodon-software.com/algorithms/android/2010/06/20/euclidean-bipartite-matching-multi-touch-and-android/
whether that's what is implemented I don't know, I'm assuming this because
Documentation/multi-touch-protocol.txt mentions this algorithm.

there is no reference in the code what "adjust_dual" could mean, and
right now I have several wikipedia pages open for Lagrange Relaxation,
positive-definite matrix, Euclidean Bipartite Matching and it doesn't make
code review any easier. I failed to find what "overcover" means and
what a reduced matrix is took me about 20 minutes to find. Turns out it's
not the Row Echelon Form (most google hits for "reduced matrix") but a
"reduced cost matrix" (says input-mt.h) which has something to do with the
travelling salesman problem. Which makes sense since EBM is a graph problem
but at that point I gave up and went back to fixing a segfault which was
much more rewarding than this rabbit hole.

I'm not arguing against the code, it clearly does in 40 lines what would
otherwise be a lot longer and I appreciate that you added the fix for the
cursor jump (well, I assume so, it's not like I can decipher the 
algorithm :). but the approach limits the number of eyes that can review it
for correctness.

meanwhile, for people without a higher degree in mathematics can we at least
add references so there are some starting points to understanding this
code? And little things like naming variables so there's no guesswork
necessary what they can mean.

Thanks

Cheers,
   Peter
