Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaIZSMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:12:00 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:36348 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbaIZSL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:11:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net,
        Cong Wang <cwang@twopensource.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
Date: Fri, 26 Sep 2014 11:10:31 -0700
In-Reply-To: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	(Nicolas Dichtel's message of "Tue, 23 Sep 2014 15:20:25 +0200")
Message-ID: <87ppei45ig.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19GmMXRCSai0mQRcn1okIeBzvFvUYv2fkk=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Nicolas Dichtel <nicolas.dichtel@6wind.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:

> The goal of this serie is to be able to multicast netlink messages with an
> attribute that identify a peer netns.
> This is needed by the userland to interpret some informations contained in
> netlink messages (like IFLA_LINK value, but also some other attributes in case
> of x-netns netdevice (see also
> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).

I want say that the problem addressed by patch 3/5 of this series is a
fundamentally valid problem.  We have network objects spanning network
namespaces and it would be very nice to be able to talk about them in
netlink, and file descriptors are too local and argubably too heavy
weight for netlink quires and especially for netlink broadcast messages.

Furthermore the concept of ineternal concept of peernet2id seems valid.

However what you do not address is a way for CRIU (aka process
migration) to be able to restore these ids after process migration.
Going farther it looks like you are actively breaking process migration
at this time, making this set of patches a no-go.

When adding a new form of namespace id CRIU patches are just about
as necessary as iproute patches.

> Ids are stored in the parent user namespace. These ids are valid only inside
> this user namespace. The user can retrieve these ids via a new netlink messages,
> but only if peer netns are in the same user namespace.

That does not describe what you have actually implemented in the
patches.

I see two ways to go with this.

- A per network namespace table to that you can store ids for ``peer''
  network namespaces.  The table would need to be populated manually by
  the likes of ip netns add.

  That flips the order of assignment and makes this idea solid.

  Unfortunately in the case of a fully referencing mesh of N network
  namespaces such a mesh winds up taking O(N^2) space, which seems
  undesirable.

- Add a netlink attribute that says this network element is in a peer
  network namespace.

  Add a unicast query message that let's you ask if the remote
  end of a tunnel is in a network namespace specified by file
  descriptor.

I personally lean towards the second version as it is fundamentally
simpler, and generally scales better, and the visibility controls are
the existing visibility controls.  The only downside is it requires
a query after receiving a netlink broadcast message for the times that
we care.

Eric
