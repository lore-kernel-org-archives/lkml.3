Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaHDO7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:59:23 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:50287 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbaHDO7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:59:21 -0400
Date: Mon, 4 Aug 2014 09:59:19 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] doc: this_cpu_ops.txt: clarify remote accesses
 of per cpu areas
In-Reply-To: <1407029436-26671-1-git-send-email-bobby.prani@gmail.com>
Message-ID: <alpine.DEB.2.11.1408040952050.8248@gentwo.org>
References: <1407029436-26671-1-git-send-email-bobby.prani@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2014, Pranith Kumar wrote:

> +Remote access to per cpu data
> +------------------------------
> +
> +Per cpu data structures are designed to be used by one cpu exclusively.
> +If you use the variables as intended, this_cpu_ops() are guaranteed to
> +be "atomic" as no other CPU has access to these data structures. In this
> +context, a remote access means an access to a per cpu data structure
> +from a CPU without using the this_cpu_* operations.

Access to the per cpu is valid in preempt safe sections by using
this_cpu_ptr() to calculate a basic addresa and then using this pointer
modifying per cpu variables.


> +There are special cases where you might need to access per cpu data
> +structures remotely. One such case is to perform maintenance tasks of
> +idle CPUs without having to wake them up using IPIs for power saving
> +purposes. It is usually safe to do a remote read access and that is

I am not sure what the "maintenance tasks" sentence is doing in here. This
looks like we are discussing read access. Maintenance implies write.

Regular remote access is a read acess to summarize counters and that
should be discussed first.

> +frequently done to summarize counters. Remote write access is the one
> +which is problematic. Remote write accesses to per cpu data structures
> +are highly discouraged until absolutely necessary. Please consider using
> +an IPI to wake up the remote CPU and perform the update to its per cpu
> +area.
> +
> +To access per-cpu data structure remotely, you need to convert the
> +per-cpu offset to a pointer using this_cpu_ptr().
> +
> +	DEFINE_PER_CPU(struct data, datap);
> +	struct data *p = per_cpu(&datap, cpu);
> +
> +p can now be passed to another CPU to be updated remotely.

Again this is not the typical way of doing things.
Remote cpus usually use per_cpu_ptr(percpustruct, cpu) to calculate the
adress of a variable in a remote percpu areas.

The approach presented here is not recommended because it implies the
adress of a local percpu struct being pushed to other cpus which may not
be aware of the nature of the storage area that they access. percpu_ptr()
makes it clear in a loop or so that we are performing remote percpu data
access now.
