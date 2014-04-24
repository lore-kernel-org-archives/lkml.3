Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaDXVYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:24:09 -0400
Received: from longford.logfs.org ([213.229.74.203]:43198 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaDXVYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:24:07 -0400
Date: Thu, 24 Apr 2014 17:23:13 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, cxie@redhat.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
Message-ID: <20140424212313.GB25446@logfs.org>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
 <20140424005247.GA17713@logfs.org>
 <20140424194024.GA25446@logfs.org>
 <20140424195821.GA3092@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140424195821.GA3092@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 April 2014 12:58:21 -0700, Greg Kroah-Hartman wrote:
> > @@ -868,11 +870,20 @@ static size_t print_time(u64 ts, char *buf)
> >  
> >  	rem_nsec = do_div(ts, 1000000000);
> >  
> > +#ifdef CONFIG_PRINTK_CPU
> > +	if (!buf)
> > +		return snprintf(NULL, 0, "[%5lu.000000,%02x] ",
> 
> %02x for a cpu?  What happens on machines with 8k cpus?

You should get something like:
Apr 23 10:34:03 [  228.950926,1a] Call Trace:
Apr 23 10:34:03 [  228.950926,201] Call Trace:
Apr 23 10:34:03 [  228.950928,1a]  [<ffffffff815e0f29>] schedule+0x29/0x70
...

That said, I don't have access to hardware with >256 cpus and haven't
actually tested this.

> And is this really an issue?  Debugging by using printk is fun, but not
> really something that people need to add a cpu number to.  Why not just
> use a tracepoint in your code to get the needed information instead?

Yes, this is an issue.  There have been several instances in my life
when I would have had to guess which function belonged to which
backtrace without this patch.  Good guesses take a long time, bad
guesses are nearly useless and giving up means you cannot debug the
issue.

I don't have a good example at hand, but here is something from a
quick grep for illustration.
Feb 22 19:04:46 [   11.642470,2e] Call Trace:
Feb 22 19:04:46 [   11.642472,16] Call Trace:
Feb 22 19:04:46 [   11.642476,29]  [<ffffffff81115bf8>] pcpu_alloc+0x988/0xa20
Feb 22 19:04:46 [   11.642481,01]  [<ffffffff810992ad>] ?  find_symbol+0x3d/0xb0
Feb 22 19:04:46 [   11.642489,05]  [<ffffffff81115bf8>] pcpu_alloc+0x988/0xa20
Feb 22 19:04:46 [   11.642493,12]  [<ffffffff81115bf8>] pcpu_alloc+0x988/0xa20
Feb 22 19:04:46 [   11.642498,08]  [<ffffffff81115bf8>] pcpu_alloc+0x988/0xa20
Feb 22 19:04:46 [   11.642504,21]  [<ffffffff810992ad>] ?  find_symbol+0x3d/0xb0

And are you seriously suggesting I use a tracepoint for kernel panics? ;)

Jörn

--
There's nothing better for promoting creativity in a medium than
making an audience feel "Hmm ­ I could do better than that!"
-- Douglas Adams in a slashdot interview
