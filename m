Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbbAKBAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 20:00:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38179 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbbAKBAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 20:00:39 -0500
Date: Sun, 11 Jan 2015 01:00:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hauke Mehrtens <hauke@hauke-m.de>,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org
Subject: Re: /proc/net/dev regression
Message-ID: <20150111010036.GD22149@ZenIV.linux.org.uk>
References: <20150110232518.GA3212@linux-g29b.site>
 <20150111002706.GC22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111002706.GC22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 12:27:06AM +0000, Al Viro wrote:
> On Sat, Jan 10, 2015 at 11:25:18PM +0000, Carlos R. Mafra wrote:
> > [mafra@linux-g29b:wmnet]$ cat net_dev_bad.txt
> > Inter-|   Receive                                                |  Transmit
> >  face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
> >     lo:     600       8    0    0    0     0          0         0      600       8    0    0    0     0       0          0
> > wlp3s0b1: 9266848    7298    0    0    0     0          0         0   372229    4030    0    0    0     0       0          0
> > 
> > And for some reason this change confuses 'wmnet'. Reading the source code
> > of 'wmnet' I found that it reads the packets as follows,
> > 
> > 	totalpackets_in = strtoul(&buffer[15], NULL, 10);
> > 
> > I am not sure if 'wmnet' could do this better (any suggestions?),
> 
> *snort*
> 
> well, yes - it's called scanf().  And if one is really, really nervous
> about the overhead of <gasp> parsing a bunch of integers (as if fopen/
> fgets/fclose alone won't cost enough to make constantly calling that
> sucker a bad idea), just use ptr + <something> - 6 instead of
> &buffer[<something>] in there.  That thing has just found where the
> colon was (and replaced it with NUL), so dealing with "the first field
> turned out to be too long and shifted everything past it" isn't hard.
> 
> > but the fact is that it was working before and now it is not.
> 
> True.  Mind you, the real issue is that this code expects the interface
> names to be never longer than 6 characters, but then /proc/net/dev layout
> strongly suggests that.  Hell knows; it is a regression and it does
> break real-world userland code.  The only way to avoid that, AFAICS, is
> to prohibit interface names longer than 6 chars ;-/
> 
> Lovely combination of crappy ABI (procfs file layout), crappy userland
> code relying on details of said ABI out of sheer laziness and triggering
> kernel change producing bloody long interface names...
> 
> Incidentally, sufficiently long interface name will produce other fun issues
> for a docked app - it simply won't fit into 64x64 square on screen ;-)

Mind you, assuming that columns will align is obviously broken - the producing
side of that thing is
        seq_printf(seq, "%6s: %7llu %7llu %4llu %4llu %4llu %5llu %10llu %9llu "
                   "%8llu %7llu %4llu %4llu %4llu %5llu %7llu %10llu\n",
                   dev->name, stats->rx_bytes, stats->rx_packets,
                   stats->rx_errors,
                   stats->rx_dropped + stats->rx_missed_errors,
                   stats->rx_fifo_errors,
                   stats->rx_length_errors + stats->rx_over_errors +
                    stats->rx_crc_errors + stats->rx_frame_errors,
                   stats->rx_compressed, stats->multicast,
                   stats->tx_bytes, stats->tx_packets,
                   stats->tx_errors, stats->tx_dropped,
                   stats->tx_fifo_errors, stats->collisions,
                   stats->tx_carrier_errors +
                    stats->tx_aborted_errors +
                    stats->tx_window_errors +
                    stats->tx_heartbeat_errors,
                   stats->tx_compressed);
To start with, expecting the ->rx_bytes to remain a 7-digit number is somewhat,
er, odd.  Long interace names be damned, the columns will not stay aligned,
no matter what.  Unless your interface vanishes as soon as it has sent
or received 10 megabytes, that is...
