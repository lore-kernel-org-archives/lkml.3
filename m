Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaAPRKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:10:15 -0500
Received: from www.sr71.net ([198.145.64.142]:42493 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbaAPRKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:10:10 -0500
Message-ID: <52D81214.7070608@sr71.net>
Date: Thu, 16 Jan 2014 09:08:36 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] re-shrink 'struct page' when SLUB is on.
References: <20140103180147.6566F7C1@viggo.jf.intel.com> <20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org> <20140106043237.GE696@lge.com> <52D05D90.3060809@sr71.net> <20140110153913.844e84755256afd271371493@linux-foundation.org> <52D0854F.5060102@sr71.net> <CAOJsxLE-oMpV2G-gxrhyv0Au1tPd87Ow57VD5CWFo41wF8F4Yw@mail.gmail.com> <alpine.DEB.2.10.1401111854580.6036@nuc> <20140113014408.GA25900@lge.com> <52D41F52.5020805@sr71.net> <alpine.DEB.2.10.1401141404190.19618@nuc> <52D5B48D.30006@sr71.net> <alpine.DEB.2.10.1401161041160.29778@nuc>
In-Reply-To: <alpine.DEB.2.10.1401161041160.29778@nuc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 08:44 AM, Christoph Lameter wrote:
> On Tue, 14 Jan 2014, Dave Hansen wrote:
> 
>> On 01/14/2014 12:07 PM, Christoph Lameter wrote:
>>> One easy way to shrink struct page is to simply remove the feature. The
>>> patchset looked a bit complicated and does many other things.
>>
>> Sure.  There's a clear path if you only care about 'struct page' size,
>> or if you only care about making the slub fast path as fast as possible.
>>  We've got three variables, though:
>>
>> 1. slub fast path speed
> 
> The fast path does use this_cpu_cmpxchg_double which is something
> different from a cmpxchg_double and its not used on struct page.

Yeah, I'm confusing the two.  I might as well say: "slub speed when
touching 'struct page'"

>> Arranged in three basic choices:
>>
>> 1. Big 'struct page', fast, medium complexity code
>> 2. Small 'struct page', slow, lowest complexity
> 
> The numbers that I see seem to indicate that a big struct page means slow.

This was a really tight loop where the caches are really hot, but it did
show the large 'struct page' winning:

	http://sr71.net/~dave/intel/slub/slub-perf-20140109.png

As I said in the earlier description, the paravirt code doing interrupt
disabling was what really hurt the two spinlock cases.

