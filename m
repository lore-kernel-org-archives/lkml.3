Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaHHULr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:11:47 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:62782 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaHHULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <1407402199.5141.283.camel@marge.simpson.net>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<8738dm9t4z.fsf@tassilo.jf.intel.com>
	<1406532289.5133.223.camel@marge.simpson.net>
	<CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	<1407059776.5156.108.camel@marge.simpson.net>
	<CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
	<1407303693.5090.171.camel@marge.simpson.net>
	<CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
	<1407402199.5141.283.camel@marge.simpson.net>
Date: Fri, 8 Aug 2014 13:11:42 -0700
Message-ID: <CA+80gGZWSeoHFM-_uoGFCw4nJAkQGfTjEKfSyAaqTw6xmUVMvA@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 2:03 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> task priority cannot be used by any task to describe a critical section.
> I assert that is that there is _zero_ critical section information present.

This appears to be the crux of our disagreement.

This assertion is incorrect. The use of RT to bracket a critical section
obviously _does_ provide the following information:

1) designation of entry point for the start of critical activity

2) designation of exit point, albeit with timing not known in advance at entry
time

3) priority value which embodies a developer's assessment of the importance of
this critical activity relative to other critical activities within the
application or coherent application set, and thus a statement about the cost of
the activity's preemption for this application or application set

What priority protection _does not_ provide is:

1) advance (at entry time) estimate of the duration of the activity

2) the measure of preemption cost in "objective" (uniform) units that would
span across unrelated applications

3) and in units that can be easily stacked against the policy-specified cost of
deferring and penalizing normal tasks for too long (although to an extent in RT
use case this is done by rt_bandwidth)

The implication of (2) and (3) is that one cannot easily have a system
management slider saying "penalize application A for the benefit of application
B (or default undesignated applications) by giving weights so-and-so to their
cost factors"... Well, in a way and to an extent one can do it by remapping
priority ranges for tasks A and B, however since priority interface was not
designed for it grounds up that would be cumbersome.

The provisioning of this missing information however is not realistically
possible outside of the simplest use cases ran in a fixed configuration under a
fixed workload, as I elaborated in the previous message.  Outside of such
irrealistic "lab" samples, even in the case of the simplest cost function the
estimates of T and X are not pragmatically obtainable. The estimates of Y and
T2 (cut-off point for Y accrual) are likewise hard or even harder to obtain.
Thus even the simplest cost function cannot be pragmatically provided, let
alone any more complex cost function.

The issue is not with inventing some sophisticated cost function and system
interface to plug it in. The issue is that valid input data that the cost
function would need to rely on is not pragmatically/economically obtainable.
(And this issue is not pragmatically solvable through dynamically collecting
such data at run time as well.)

Therefore there is no any pragmatically usable "better" solution in the domain
of preemption-deferral solutions (rather than post-preemption solutions) that
may be discovered yet.

It stands to reason that the choice in this domain is really, and will ever
pragmatically stay, between using the long-existing techniques (i.e. priority
protection or schedctl-style preempt delay, with the latter having the
limitations I outlined earlier) or not using anything at all.

- Sergey
