Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaABXsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:48:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:42721 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaABXsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:48:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,593,1384329600"; 
   d="scan'208";a="433226602"
Message-ID: <52C5FAD3.6080808@intel.com>
Date: Thu, 02 Jan 2014 15:48:35 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
References: <20140101002935.GA15683@localhost.localdomain> <52C5AA61.8060701@intel.com> <alpine.DEB.2.02.1401021357360.21537@chino.kir.corp.google.com> <52C5E3C2.6020205@intel.com> <alpine.DEB.2.02.1401021534320.492@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401021534320.492@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 03:36 PM, David Rientjes wrote:
> On Thu, 2 Jan 2014, Dave Hansen wrote:
>> Let's say enabling THP made my system behave badly.  How do I get it
>> back to the state before I enabled THP?  The user has to have gone and
>> recorded what their min_free_kbytes was before turning THP on in order
>> to get it back to where it was.  Folks also have to either plan in
>> advance (archiving *ALL* the sysctl settings), somehow *know* somehow
>> that THP can affect min_free_kbytes, or just plain be clairvoyant.
>> 
> How is this different from some initscript changing the value?  We should 
> either specify that min_free_kbytes changed from its default, which may 
> change from kernel version to kernel version itself, in all cases or just 
> leave it as it currently is.  There's no reason to special-case thp in 
> this way if there are other ways to change the value.

Ummm....  It's different because one is the kernel changing it and the
other is userspace.  If I wonder how the heck this got set:

	kernel.core_pattern = |/usr/share/apport/apport %p %s %c

I do:

$ grep -r /usr/share/apport/apport /etc/
/etc/init/apport.conf:        /usr/share/apport/apportcheckresume || true
/etc/init/apport.conf:    echo "|/usr/share/apport/apport %p %s %c" >
/proc/sys/kernel/core_pattern

There's usually a record of how it got set, somewhere, if it happened
from userspace.  Printing messages like this in the kernel does the
same: it gives the sysadmin a _chance_ of finding out what happened.
Doing it silently (like it's done today) isn't very nice.

You're arguing that "if userspace can set it arbitrarily, then the
kernel should be able to do it silently too."  That's nonsense.

It would be nice to have tracepoints explicitly for tracing who messed
with sysctl values, too.
