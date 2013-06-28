Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab3F1TKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:10:44 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52835 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3F1Szv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:51 -0400
Date: Fri, 28 Jun 2013 11:55:47 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, kmpark@infradead.org,
        hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130628185547.GA14520@teo>
References: <20130628000201.GB15637@bbox>
 <20130627173433.d0fc6ecd.akpm@linux-foundation.org>
 <20130628005852.GA8093@teo>
 <20130627181353.3d552e64.akpm@linux-foundation.org>
 <20130628043411.GA9100@teo>
 <20130628050712.GA10097@teo>
 <20130628100027.31504abe@redhat.com>
 <20130628165722.GA12271@teo>
 <20130628170917.GA12610@teo>
 <20130628144507.37d28ed9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130628144507.37d28ed9@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 02:45:07PM -0400, Luiz Capitulino wrote:
> On Fri, 28 Jun 2013 10:09:17 -0700
> Anton Vorontsov <anton@enomsg.org> wrote:
> 
> > So, I would now argue that the current scheme is perfectly OK and can do
> > everything you can do with the "strict" one,
> 
> I forgot commenting this bit. This is not true, because I don't want a
> low fd to be notified on critical level. The current interface just
> can't do that.

Why can't you use poll() and demultiplex the events? Check if there is an
event in the crit fd, and if there is, then just ignore all the rest.

> However, it *is* possible to make non-strict work on strict if we make
> strict default _and_ make reads on memory.pressure_level return
> available events. Just do this on app initialization:
> 
> for each event in memory.pressure_level; do
> 	/* register eventfd to be notified on "event" */
> done

This scheme registers "all" events. Here is more complicated case:

Old kernels, pressure_level reads:

  low, med, crit

The app just wants to listen for med level.

New kernels, pressure_level reads:

  low, FOO, med, BAR, crit

How would application decide which of FOO and BAR are ex-med levels?

Anton
