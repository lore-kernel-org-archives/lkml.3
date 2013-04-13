Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3DNGqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 02:46:44 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:55042 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3DNGqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 02:46:25 -0400
Date: Sat, 13 Apr 2013 12:25:34 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: cfq-iosched: update documentation help
 for cfq tunnables
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
In-Reply-To: <1364698505-22236-1-git-send-email-linkinjeon@gmail.com> (from
	linkinjeon@gmail.com on Sat Mar 30 21:55:04 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1365873934.18069.96@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning out "look at this" directory, I don't see this applied  
upstream but it may already be in Jens' tree. (That's the tree it  
should go in through...)

On 03/30/2013 09:55:04 PM, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add the documentation text for latency, target_latency & group_idle
> tunnable parameters in the block/cfq-iosched.txt.
> Also fix few typo(spelling) mistakes.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  Documentation/block/cfq-iosched.txt |   47  
> ++++++++++++++++++++++++++++++++---
>  1 file changed, 44 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/block/cfq-iosched.txt  
> b/Documentation/block/cfq-iosched.txt
> index a5eb7d1..4d02bca 100644
> --- a/Documentation/block/cfq-iosched.txt
> +++ b/Documentation/block/cfq-iosched.txt
> @@ -5,7 +5,7 @@ The main aim of CFQ scheduler is to provide a fair  
> allocation of the disk
>  I/O bandwidth for all the processes which requests an I/O operation.
> 
>  CFQ maintains the per process queue for the processes which request  
> I/O
> -operation(syncronous requests). In case of asynchronous requests,  
> all the
> +operation(synchronous requests). In case of asynchronous requests,  
> all the
>  requests from all the processes are batched together according to  
> their
>  process's I/O priority.
> 
> @@ -66,6 +66,47 @@ This parameter is used to set the timeout of  
> synchronous requests. Default
>  value of this is 124ms. In case to favor synchronous requests over  
> asynchronous
>  one, this value should be decreased relative to fifo_expire_async.
> 
> +group_idle
> +-----------
> +This parameter forces idling at the CFQ group level instead of CFQ

You don't need to say "this parameter", you can just start with "Force  
idling at..."

> +queue level. This is introduced after after a bottleneck was observed
> +in higher end storage due to idle on sequential queuee and allow  
> dispatch

queuee

> +from a single queue. The idea with this parameter is that it be be  
> run with
> +slice_idle=0 and group_idle=8, so that idling does not happen on  
> individual
> +queues in the group but happens overall on the group and still keep  
> the IO
> +controller working.
> +Not idling on individual queues in the group will dispatch requests  
> from
> +multiple queues in the group at the same time and achieve higher  
> throughput
> +on higher end storage.
> +
> +Default value for this parameter is 8ms.
> +
> +latency
> +-------
> +This parameter is used to enable/disable the latency mode of the CFQ

"Enable/disable the latency mode..."

> +scheduler. So if latency mode (called low_latency) is enabled, then  
> CFQ tries
> +to recompute the slice time for each process based on the  
> target_latency set
> +for the system. This favors the fairness over throughput. Disabling  
> low
> +latency (setting it to 0) ignores target latency, allowing each  
> process in the
> +system to get a full time slice.
> +
> +By default low latency mode is enabled.

Why are latency and target_latency separate parameters? (0 already  
disables it... the logical thing to do...?)

I.E. why does this knob even exist separate from target_latency?

> +target_latency
> +--------------
> +This parameter is used to calculate the time slice for a process if  
> cfq's
> +latency mode is enabled. It will ensure that sync requests have an  
> estimated
> +latency. But sometime if sequential workload is more (e.g.  
> sequential read),
> +then to meet the latency constraints, throughput may decrease  
> because of less
> +time for each process to issue I/O request before the cfq queue is  
> switched.
> +
> +Though this can be overcome by disabling the latency_mode, but it  
> may increase
> +the read latency for some applications. So, this parameter allows  
> for changing
> +target_latency through sysfs interface which can provide the balanced
> +throughput and read latency.
> +
> +Default value for target_latency is 300ms.

Sorry, I try not to rewrite, but this whole section can just be:

Cap outstanding I/O requests to this many miliseconds (default 300),  
ensuring sync requests have an estimated latency. Lowering this may  
decrease throughput on sequential workloads by switching queues more  
often (interleaving other I/O).

(And it could ahve been called target_latency_ms to be  
self-documenting. Oh well.)

Rob