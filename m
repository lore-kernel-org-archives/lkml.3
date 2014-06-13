Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaFMQ2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:28:17 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:35376 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbaFMQ2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:28:16 -0400
Date: Fri, 13 Jun 2014 12:28:07 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Yucong <slaoub@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de, mhocko@suse.cz,
        riel@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan.c: wrap five parameters into shrink_result
 for reducing the stack consumption
Message-ID: <20140613162807.GP2878@cmpxchg.org>
References: <1402634191-3442-1-git-send-email-slaoub@gmail.com>
 <20140612214016.1beda952.akpm@linux-foundation.org>
 <1402636875.1232.13.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402636875.1232.13.camel@debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 01:21:15PM +0800, Chen Yucong wrote:
> On Thu, 2014-06-12 at 21:40 -0700, Andrew Morton wrote:
> > On Fri, 13 Jun 2014 12:36:31 +0800 Chen Yucong <slaoub@gmail.com> wrote:
> > 
> > > @@ -1148,7 +1146,8 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
> > >  		.priority = DEF_PRIORITY,
> > >  		.may_unmap = 1,
> > >  	};
> > > -	unsigned long ret, dummy1, dummy2, dummy3, dummy4, dummy5;
> > > +	unsigned long ret;
> > > +	struct shrink_result dummy = { };
> > 
> > You didn't like the idea of making this static?
> Sorry! It's my negligence.
> If we make dummy static, it can help us save more stack.
> 
> without change:  
> 0xffffffff810aede8 reclaim_clean_pages_from_list []:	184
> 0xffffffff810aeef8 reclaim_clean_pages_from_list []:	184
> 
> with change: struct shrink_result dummy = {};
> 0xffffffff810aed6c reclaim_clean_pages_from_list []:	152
> 0xffffffff810aee68 reclaim_clean_pages_from_list []:	152
> 
> with change: static struct shrink_result dummy ={};
> 0xffffffff810aed69 reclaim_clean_pages_from_list []:	120
> 0xffffffff810aee4d reclaim_clean_pages_from_list []:	120

FWIW, I copied bloat-o-meter and hacked up a quick comparison tool
that you can feed two outputs of checkstack.pl for a whole vmlinux and
it shows you the delta.

The output for your patch (with the static dummy) looks like this:

+0/-240 -240
shrink_inactive_list                         136     112     -24
shrink_page_list                             208     160     -48
reclaim_clean_pages_from_list                168       -    -168

(The stack footprint for reclaim_clean_pages_from_list is actually 96
after your patch, but checkstack.pl skips frames under 100)

---
#!/usr/bin/python
#
# Based on bloat-o-meter 

import sys
import re

if len(sys.argv) != 3:
   print("usage: %s file1 file2" % sys.argv[0])
   sys.exit(1)

def getsizes(filename):
   sym = {}
   for line in open(filename):
      x = re.split('(0x.*) (.*) (.*):[ \t]*(.*)', line)
      try:
         foo, addr, name, src, size, bar = x
      except:
         print(x)
         raise Exception
      try:
         sym[name] = int(size)
      except:
         continue
   return sym

old = getsizes(sys.argv[1])
new = getsizes(sys.argv[2])

inc = 0
dec = 0
delta = []
common = {}

for a in old:
   if a in new:
      common[a] = 1

for name in old:
   if name not in common:
      dec += old[name]
      delta.append((-old[name], name))

for name in new:
   if name not in common:
      inc += new[name]
      delta.append((new[name], name))

for name in common:
   d = new.get(name, 0) - old.get(name, 0)
   if d > 0: inc += d
   if d < 0: dec -= d
   delta.append((d, name))

delta.sort()
delta.reverse()

print("+%d/-%d %+d" % (inc, dec, inc - dec))
for d, name in delta:
   if d:
      print("%-40s %7s %7s %+7d" % (name, old.get(name, "-"), new.get(name, "-"), d))
