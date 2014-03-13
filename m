Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaCMOzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:55:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaCMOzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:55:43 -0400
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
From: Simo Sorce <ssorce@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
In-Reply-To: <20140313141422.GB18914@redhat.com>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
	 <1394657163-7472-3-git-send-email-vgoyal@redhat.com>
	 <5320CAEC.6030008@amacapital.net>
	 <CALCETrUTjN=XKwnO62P9roZtLLuk7_9Oi17Mj_Aa2ZFtZc1gVA@mail.gmail.com>
	 <20140313141422.GB18914@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Mar 2014 10:55:34 -0400
Message-ID: <1394722534.32465.227.camel@willson.li.ssimo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 10:14 -0400, Vivek Goyal wrote:
> On Wed, Mar 12, 2014 at 02:12:33PM -0700, Andy Lutomirski wrote:
> > On Wed, Mar 12, 2014 at 2:00 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > > On 03/12/2014 01:46 PM, Vivek Goyal wrote:
> > >> Implement SO_PEERCGROUP along the lines of SO_PEERCRED. This returns the
> > >> cgroup of first mounted hierarchy of the task. For the case of client,
> > >> it represents the cgroup of client at the time of opening the connection.
> > >> After that client cgroup might change.
> > >
> > > Even if people decide that sending cgroups over a unix socket is a good
> > > idea, this API has my NAK in the strongest possible sense, for whatever
> > > my NAK is worth.
> > >
> > > IMO SO_PEERCRED is a disaster.  Calling send(2) or write(2) should
> > > *never* imply the use of a credential.  A program should always have to
> > > *explicitly* request use of a credential.  What you want is SCM_CGROUP.
> > >
> > > (I've found privilege escalations before based on this observation, and
> > > I suspect I'll find them again.)
> > >
> > >
> > > Note that I think that you really want SCM_SOMETHING_ELSE and not
> > > SCM_CGROUP, but I don't know what the use case is yet.
> > 
> > This might not be quite as awful as I thought.  At least you're
> > looking up the cgroup at connection time instead of at send time.
> > 
> > OTOH, this is still racy -- the socket could easily outlive the cgroup
> > that created it.
> 
> That's a good point. What guarantees that previous cgroup was not
> reassigned to a different container.
> 
> What if a process A opens the connection with sssd. Process A passes the
> file descriptor to a different process B in a differnt container.

Stop right here.
If the process passes the fd it is not my problem anymore.
The process can as well just 'proxy' all the information to another
process.

We just care to properly identify the 'original' container, we are not
in the business of detecting malicious behavior. That's something other
mechanism need to protect against (SELinux or other LSMs, normal
permissions, capabilities, etc...).

> Process A exits. Container gets removed from system and new one gets
> launched which uses same cgroup as old one. Now process B sends a new
> request and SSSD will serve it based on policy of newly launched
> container.
> 
> This sounds very similar to pid race where socket/connection will outlive
> the pid.

Nope, completely different.

Simo.

