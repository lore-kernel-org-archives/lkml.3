Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaBOECc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 23:02:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbaBOECb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 23:02:31 -0500
Date: Fri, 14 Feb 2014 22:58:10 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mtosatti@redhat.com, mgorman@suse.de,
        aarcange@redhat.com, andi@firstfloor.org, riel@redhat.com,
        davidlohr@hp.com, isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
Message-ID: <20140214225810.57e854cb@redhat.com>
In-Reply-To: <alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
	<1392339728-13487-5-git-send-email-lcapitulino@redhat.com>
	<alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014 15:14:22 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 13 Feb 2014, Luiz Capitulino wrote:
> 
> > From: Luiz capitulino <lcapitulino@redhat.com>
> > 
> > The HugeTLB command-line option hugepages= allows a user to specify how
> > many huge pages should be allocated at boot. This option is needed because
> > it improves reliability when allocating 1G huge pages, which are better
> > allocated as early as possible due to fragmentation.
> > 
> > However, hugepages= has a limitation. On NUMA systems, hugepages= will
> > automatically distribute memory allocation equally among nodes. For
> > example, if you have a 2-node NUMA system and allocate 200 huge pages,
> > than hugepages= will try to allocate 100 huge pages from node0 and 100
> > from node1.
> > 
> > This is very unflexible, as it doesn't allow you to specify which nodes
> > the huge pages should be allocated from. For example, there are use-cases
> > where the user wants to specify that a 1GB huge page should be allocated
> > from node 2 or that 300 2MB huge pages should be allocated from node 0.
> > 
> > The hugepages_node= command-line option introduced by this commit allows
> > just that.
> > 
> > The syntax is:
> > 
> >   hugepages_node=nid:nr_pages:size,...
> > 
> 
> Again, I think this syntax is horrendous and doesn't couple well with the 
> other hugepage-related kernel command line options.  We already have 
> hugepages= and hugepagesz= which you can interleave on the command line to 
> get 100 2M hugepages and 10 1GB hugepages, for example.
> 
> This patchset is simply introducing another variable to the matter: the 
> node that the hugepages should be allocated on.  So just introduce a 
> hugepagesnode= parameter to couple with the others so you can do
> 
> 	hugepagesz=<size> hugepagesnode=<nid> hugepages=<#>

That was my first try but it turned out really bad. First, for every node
you specify you need three options. So, if you want to setup memory for
three nodes you'll need to specify nine options. And it gets worse, because
hugepagesz= and hugepages= have strict ordering (which is a mistake, IMHO) so
you have to specify them in the right order otherwise things don't work as
expected and you have no idea why (have been there myself).

IMO, hugepages_node=<nid>:<nr_pages>:<size>,... is good enough. It's concise,
and don't depend on any other option to function. Also, there are lots of other
kernel command-line options that require you to specify multiple fields, so
it's not like hugepages_node= is totally different in that regard.

> 
> instead of having completely confusing interfaces where you want to do 
> hugepages_node=1:1:1G for a 1GB hugepage on page 1 (and try remembering 
> which "1" means what, yuck) and "hugepagesz=1GB hugepages=1" if you're 
> indifferent to the node.
> 
