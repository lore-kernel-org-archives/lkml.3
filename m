Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbaHEIr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:47:58 -0400
Received: from mta-out1.inet.fi ([62.71.2.201]:46545 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441AbaHEIrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:47:55 -0400
Date: Tue, 5 Aug 2014 11:46:14 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH, RESEND] procfs: silence lockdep warning about read vs.
 exec seq_file
Message-ID: <20140805084614.GA22025@node.dhcp.inet.fi>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name>
 <87d2cfzjos.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2cfzjos.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 08:42:11PM -0700, Eric W. Biederman wrote:
> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
> 
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > Testcase:
> >
> >   cat /proc/self/maps >/dev/null
> >   chmod +x /proc/self/net/packet
> >   exec /proc/self/net/packet
> >
> > It triggers lockdep warning:
> 
> > I don't know why we allow "chmod +x" on some proc files, notably net-related.
> > Is it a bug?
> 
> It looks like we simply did not remove the ability to make those files
> executable when we realized executable proc files could be a problem.
> 
> I expect that part of proc could use an audit where someone figures out
> what makes sense.  It does appear that chmod XXX /proc/generic_file
> is explicitly supported.  So we would have to be delicate with any
> changes in that area to avoid creating userspace regressions.

I can't imagine valid use-case, taking into account that changing access
rights for one PID changes it for every PID. It's potential security hole
if user is not aware about this (I wasn't until recently).

List of files under /proc/PID/ which doesn't fail chmod to its current
access rights -- chmod "$(stat --format="%a" "$file")" "$file":

net/anycast6
net/arp
net/connector
net/dev
net/dev_mcast
net/dev_snmp6/eth0
net/dev_snmp6/lo
net/fib_trie
net/fib_triestat
net/icmp
net/icmp6
net/if_inet6
net/igmp
net/igmp6
net/ip6_flowlabel
net/ip6_tables_matches
net/ip6_tables_names
net/ip6_tables_targets
net/ip_mr_cache
net/ip_mr_vif
net/ip_tables_matches
net/ip_tables_names
net/ip_tables_targets
net/ipv6_route
net/mcfilter
net/mcfilter6
net/netfilter/nf_log
net/netlink
net/netstat
net/nf_conntrack
net/nf_conntrack_expect
net/packet
net/pnp
net/protocols
net/psched
net/ptype
net/raw
net/raw6
net/route
net/rt6_stats
net/rt_cache
net/snmp
net/snmp6
net/sockstat
net/sockstat6
net/softnet_stat
net/stat/arp_cache
net/stat/ndisc_cache
net/stat/nf_conntrack
net/stat/rt_cache
net/tcp
net/tcp6
net/udp
net/udp6
net/udplite
net/udplite6
net/unix

David, could you comment on this?

-- 
 Kirill A. Shutemov
