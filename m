Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaDQQNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaDQQM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:12:57 -0400
Date: Thu, 17 Apr 2014 12:12:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Daniel J Walsh <dwalsh@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Simo Sorce <ssorce@redhat.com>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
Message-ID: <20140417161253.GC15749@redhat.com>
References: <20140416002010.GA5035@redhat.com>
 <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
 <20140416.085743.1614257692560892039.davem@davemloft.net>
 <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
 <1397664837.19767.410.camel@willson.li.ssimo.org>
 <CALCETrXn7b6UuALpGUVoyQYfR2uzk5tj2ABV=dkvtFNgqM5sxQ@mail.gmail.com>
 <20140416180642.GG31074@redhat.com>
 <CALCETrVUw5+vCCONy1VTXpskbY_eZFo2CtbehwV5Mhj4d4+icw@mail.gmail.com>
 <20140416185936.GJ31074@redhat.com>
 <534FF61B.4010901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534FF61B.4010901@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 08:41:15AM -0700, Daniel J Walsh wrote:

[..]
> The two use cases for this patch are:
> 
> 1 Logging, to make sure the cgroup information gets correctly attributed
> to the caller. 
> 
> 2 Potentially reveal different information to the caller based on the
> cgroup information. 
> 
> Imagine you want to set up an apache web server that is going to use
> sssd for authentication data.  You might want to reveal a limited set of
> users to the apache service process based on the fact that it is running
> in the apache.service.slice.  If the apache service does the equivalent
> of getent passwd I want to give it different information then say sshd
> did the same calls.

Dan,

So in first case we should be fine with both SO_PEERCGROUP and
SO_PASSCGROUP. cgroup information is not being used as some sort of
security attribute and decide who can access what.

Second use case looks more like that cgroup information is being used
as some sort of security attribute to decide who gets to see what
information.

cgroup retrieved from SO_PEERCGROUP and used as an identifier to
decide who can access what should be safe. This is similar to doing
security checks at open(2) time.

Andy's contention is that cgroup information received using SO_PASSCGROUP
is not safe to use for some sort of authorization. And reason being that
socket file descriptors can be passed around and one can trick an 
priviliged process to write to that descriptor, making receiver believe
that priviilged process is asking for some info.

Now there are caveats to it. So far all the examples I have seen are
the ones where setuid program will run in same cgroup as client. So even
if we trick setuid program to write to socket fd, cgroup information
remains same.

I think problem will happen only in advance cases where priviliged
program is running in some other cgroup and if it accepts file
descritors and writes to them. I don't know if it is a common practice
or not.

May be we should just make it very clear that if cgroup information
is being used for any kind of authorization purposes, then use only
SO_PEERCGROUP. Limit SO_PASSCGROUP cgroup info for usages like logging.

Thanks
Vivek
