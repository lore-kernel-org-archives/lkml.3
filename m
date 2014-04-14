Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaDNJTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:19:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbaDNJTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:19:50 -0400
Date: Mon, 14 Apr 2014 11:19:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@kernel.org, namhyung@kernel.org, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/5] perf: Enable multiple hist_entry_group output
Message-ID: <20140414091932.GC1433@krava.brq.redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
 <1397160661-33395-6-git-send-email-dzickus@redhat.com>
 <20140411173000.GC22707@krava.brq.redhat.com>
 <20140411183452.GK8488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411183452.GK8488@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 02:34:52PM -0400, Don Zickus wrote:
> On Fri, Apr 11, 2014 at 07:30:00PM +0200, Jiri Olsa wrote:

SNIP

> > and with your changes we could do:
> > 
> >    Overhead   CPU  symbol
> >    ........   ...  ......
> >    90%        0
> >         50%        krava1
> >         20%        krava2
> >         30%        krava3
> > 
> >    10%        1
> >         50%        krava4
> >         50%        krava5
> >   
> > 
> > I wonder we could go more generic and allow more nested groups,
> > like eg allow group sort on cpu and pid (or more):
> > 
> >    Overhead   CPU  pid  symbol
> >    ........   ...  ...  ......
> >    90%        0
> >       50%          100
> >         50%             krava1
> >         20%             krava2
> >         30%             krava3
> >       50%          110
> >         50%             krava1
> >         20%             krava2
> >         30%             krava3
> > 
> >    10%        1
> >       100%         200
> >         50%             krava4
> >         50%             krava5
> > 
> > 
> > I glanced over the changes and I wonder we could do it
> > by chaining hists structs via 'struct hist_entry'
> > 
> > like adding 'struct hists' into 'struct hists_entry'
> > and making the sort_order local for each 'struct hists'
> 
> Unless you meant:
> 
> hists
>  \- hist_entry
>       \- hists
>            \- hist_entry -> hist_entry -> hist_entry -> hist_entry
>                               \- hists
>                                    \- hist_entry -> hist_entry -> hist_entry
> 
> where each 'hists' represents a new group and a hist_entry->hists != NULL
> is a group otherwise just a node?

right, hist_entry is either node or leaf, I see it like this:

hists (A)
  \-hist_entry(A)->(hists B1)
                     \-hist_entry(B1)
                     \-hist_entry(B1)
                     \-hist_entry(B1)

  \-hist_entry(A)->(hists B2)
                     \-hist_entry(B2)

  \-hist_entry(A)->(hists B3)
                     \-hist_entry(B3)
                     \-hist_entry(B3)


hists (A)  - getting data groupped by CPU - hist_entry (A)
hists (BX) - getting data belonging to CPU group and groupped by symbol (hist_entry BX)

so hists(A) provides data for 1st column in Overhead,
and hists(BX) provides data for the 2nd one:

  Overhead   CPU  symbol
  ........   ...  ......
  90%        0
       50%        krava1
       20%        krava2
       30%        krava3

   5%        1
      100%        krava4

   5%        2
       50%        krava4
       50%        krava5


jirka
