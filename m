Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbbADUXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:23:34 -0500
Received: from ec2-54-201-57-178.us-west-2.compute.amazonaws.com ([54.201.57.178]:54467
	"EHLO ip-172-31-12-36.us-west-2.compute.internal"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752761AbbADUXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:23:33 -0500
Date: Sun, 4 Jan 2015 20:19:45 +0000
From: dwalker@fifo99.com
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: add per console loglevel
Message-ID: <20150104201945.GA15792@fifo99.com>
References: <20141220224908.GB4466@fifo99.com>
 <20141221194753.49c12693@neptune.home>
 <20141223162013.GB19144@fifo99.com>
 <20141223221324.11d00624@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141223221324.11d00624@neptune.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 10:13:24PM +0100, Bruno Prémont wrote:
> On Tue, 23 December 2014 dwalker@fifo99.com wrote:
> > On Sun, Dec 21, 2014 at 07:47:53PM +0100, Bruno Prémont wrote:
> > > On Sat, 20 December 2014 dwalker@fifo99.com wrote:
> > > > This adds to to the console= command line options allowing the
> > > > addition of a per console log level setting.
> > > > 
> > > > examples,
> > > > 
> > > > 	console=ttyS0,ll4
> > > > 	console=tty0,ll6
> > > > 
> > > > This can be used on systems which have multiple serial consoles, but
> > > > it's desired for logging to be light on one and heavy on another.
> > > 
> > > Looks useful to me.
> > > What would be the best way to make these per-console loglevels
> > > configurable at runtime? `dmesg -n $LEVEL` only affects the global
> > > limit.
> > > 
> > > One drawback to letting global loglevel have precedence is that
> > > all consoles that should not get detailed log messages need to have
> > > their loglevel explicitly lowered and it's not possible to have
> > > one console forced to show more than the global loglevel.
> > 
> > Right, reason for the patch.
> >  
> > > 
> > > An approach I would prefer is to have all consoles follow global
> > > loglevel except when something different had been explicitly requested
> > > for them.
> > 
> > This patch is mostly like this. It breaks down when you set the "llX"
> > parameter to something above KERN_NOTICE, and the global one is also
> > set above that.
> 
> In your patch global filter applies first, then what passes global filter
> gets filtered with the per-console filter.
> 
> So I can't have `dmesg -n 3` and "console=ttyS0,ll8 console=tty0"
> to get my debugging output over serial console.

Yeah .. This would improve things. I changed it after I sent the first patch, but it
looks like one of your patches changes it also.

I was a little concerned about altering the fast path in call_console_drivers().. With
the changes I made each call into call_console_drivers is forced to go thru the whole list
of consoles, instead of short circuiting prior to the list.
 
I was thinking the max local and global log level could be saved and used for short circuiting
instead of using the global log level.

> > > This way a single console can be added later on (e.g. netconsole)
> > > and set to pass through debug messages without affecting anyone else.
> 
> Netconsole console can be added at any time when system is running
> either through loading of its module or using dynamic configuration
> via configfs.
> 
> See also my patches.

Yeah, I saw them .. Not in too much detail, but it seems worth while for it to
work with netconsole.

Daniel
