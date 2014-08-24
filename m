Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaHXOtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:49:53 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:32863 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaHXOtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:49:51 -0400
Date: Sun, 24 Aug 2014 16:49:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        peterz@infradead.org, mingo@redhat.com, ak@linux.intel.com,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org, cl@linux.com,
        penberg@kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        lauraa@codeaurora.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [v3] warn on performance-impacting configs aka.
 TAINT_PERFORMANCE
Message-ID: <20140824144946.GC9455@gmail.com>
References: <20140821202424.7ED66A50@viggo.jf.intel.com>
 <20140822072023.GA7218@gmail.com>
 <53F75B91.2040100@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F75B91.2040100@sr71.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> On 08/22/2014 12:20 AM, Ingo Molnar wrote:
> > Essentially all DEBUG_OBJECTS_* options are expensive, assuming 
> > they are enabled, i.e. DEBUG_OBJECTS_ENABLE_DEFAULT=y.
> > 
> > Otherwise they should only be warned about if the debugobjects 
> > boot option got enabled.
> > 
> > I.e. you'll need a bit of a runtime check for this one.
> 
> At that point, what do we print, and when do we print it?  We're not
> saying that the config option should be disabled because it's really the
> boot option plus the config option that is causing the problem.
> 
> I'll just put the DEBUG_OBJECTS_ENABLE_DEFAULT in here which is
> analogous to what we're doing with SLUB_DEBUG_ON.
> 
> >> +static ssize_t performance_taint_read(struct file *file, char __user *user_buf,
> >> +			size_t count, loff_t *ppos)
> >> +{
> >> +	int i;
> >> +	int ret;
> >> +	char *buf;
> >> +	size_t buf_written = 0;
> >> +	size_t buf_left;
> >> +	size_t buf_len;
> >> +
> >> +	if (!ARRAY_SIZE(perfomance_killing_configs))
> >> +		return 0;
> >> +
> >> +	buf_len = 1;
> >> +	for (i = 0; i < ARRAY_SIZE(perfomance_killing_configs); i++)
> >> +		buf_len += strlen(config_prefix) +
> >> +			   strlen(perfomance_killing_configs[i]);
> >> +	/* Add a byte for for each entry in the array for a \n */
> >> +	buf_len += ARRAY_SIZE(perfomance_killing_configs);
> >> +
> >> +	buf = kmalloc(buf_len, GFP_KERNEL);
> >> +	if (!buf)
> >> +		return -ENOMEM;
> >> +
> >> +	buf_left = buf_len;
> >> +	for (i = 0; i < ARRAY_SIZE(perfomance_killing_configs); i++) {
> >> +		buf_written += snprintf(buf + buf_written, buf_left,
> >> +					"%s%s\n", config_prefix,
> >> +					perfomance_killing_configs[i]);
> >> +		buf_left = buf_len - buf_written;
> > 
> > So, ARRAY_SIZE(performance_killing_configs) is written out four 
> > times, a temporary variable would be in order I suspect.
> 
> If one of them had gone over 80 chars, I probably would have. :)  I put
> one in anyway.
> 
> > Also, do you want to check buf_left and break out early from 
> > the loop if it goes non-positive?
> 
> You're slowly inflating my patch for no practical gain. :)

AFAICS it's a potential memory corruption and security bug, 
should the array ever grow large enough to overflow the passed
in buffer size.

Thanks,

	Ingo
