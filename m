Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaCJIjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaCJIjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:39:09 -0400
Date: Mon, 10 Mar 2014 16:38:34 +0800
From: WANG Chao <chaowang@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Muli Ben-Yehuda <muli@cs.technion.ac.il>,
        "Jon D. Mason" <jdmason@kudzu.us>, "H. Peter Anvin" <hpa@zytor.com>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, calgary: use 8M TCE table size by default
Message-ID: <20140310083834.GA32547@dhcp-17-89.nay.redhat.com>
References: <1394179816-15435-1-git-send-email-chaowang@redhat.com>
 <20140307141413.GF1326@redhat.com>
 <20140307155204.GC30641@dhcp-17-89.nay.redhat.com>
 <20140307160906.GH1326@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307160906.GH1326@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 at 11:09am, Vivek Goyal wrote:
> On Fri, Mar 07, 2014 at 11:52:04PM +0800, WANG Chao wrote:
> > Hi, Vivek
> > 
> > On 03/07/14 at 09:14am, Vivek Goyal wrote:
> > > On Fri, Mar 07, 2014 at 04:10:16PM +0800, WANG Chao wrote:
> > > 
> > > [..]
> > > >  	}
> > > >  
> > > > -	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
> > > > -					saved_max_pfn : max_pfn) * PAGE_SIZE);
> > > > +	specified_table_size = determine_tce_table_size();
> > > 
> > > I don't think you can get rid of saved_max_pfn right away. What if
> > > somebody is using old first kernel and new second kernel. Then old kernel
> > > will still be using a table size which is smaller than 8M.
> > 
> > If TCE table size is hard coded to 8M, the new 1st kernel can never be
> > compatible with the old 2nd kernel.
> 
> I gave example of old first kernel and new second kernel, and not
> vice-versa.
> 
> So we have two scenarios.
> 
> - Old first kernel and new second kernel.
> - New first kernel and old second kernel.
> 
> If we want to make these two scenarios work with calgary, we need to
> use kexec-tools with --pass-memmap option. And also in new kernel we
> need to retain saved_max_pfn. Only difference will be, that we will
> set saved_max_pfn only if it is kdump kernel and if user passed a 
> memory map on kernel command line.

Old first kernel and new second kernel is easy to handle. Like you said,
we can use exactmap and set saved_max_pfn in kdump kernel, just as the
old way.

But it's still not clear to me how we can handle the case of new first
kernel and old second kernel.

Let's say, a calgary system has 2G memory. The new first kernel TCE
table size are hard coded to 8M. When the old kdump kernel is booting,
memmap=exactmap is parsed and saved_max_pfn is set to 2G/PAGE_SIZE. TCE
table size is determined by 2G ram size. So the size is 4M. We run into
the situation that TCE table is 8M in first kernel and 4M in second
kernel. This inconsistency of TCE table size would cause kdump kernel
fails somehow, that's why we brought in saved_max_pfn in the first place
as you know.

The problem is how to keep TCE table size being consistent between new
first kernel and old second kernel.

I can only think of exporting this value to user space but once we does
that, this knob file could introduce another layer of backward
compatible issue in the future.

> 
> So it is doable if it want to do it.
> 
> Now the real question is, is it worth introducing all this complication
> and confusion given the fact most of the people use same first and second
> kernel and given the fact that calgary is old hardware. What are the
> chances somebody will run into it.

I understand. I'd definitely try to keep things compatible between
the new and old if that's doable. But chances that people would run into
an issue may be lower than both of us think.

> 
> I would say it is not very complicated to maintain backward compatibility
> in this case. So let us keep saved_max_pfn for some time and make
> kexec-tools changes. Some time down the line, one can get rid of
> saved_max_pfn completely.

I'm just not convinced that we can properly handle the case of new first
kernel and old second kernel.

Could you be more specific about how that could be solved please?

Thanks
WANG Chao
