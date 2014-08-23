Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaHWMKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 08:10:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38008 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaHWMKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 08:10:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        arozansk@redhat.com, eparis@redhat.com, sgrubb@redhat.com,
        serge@hallyn.com, Andy Lutomirski <luto@amacapital.net>
References: <cover.1408581429.git.rgb@redhat.com>
	<cover.1408581429.git.rgb@redhat.com>
	<d5bfd81a219c5c45c910494d6a3478ce83052e1f.1408581429.git.rgb@redhat.com>
Date: Sat, 23 Aug 2014 07:05:35 -0500
In-Reply-To: <d5bfd81a219c5c45c910494d6a3478ce83052e1f.1408581429.git.rgb@redhat.com>
	(Richard Guy Briggs's message of "Wed, 20 Aug 2014 21:09:34 -0400")
Message-ID: <87ioljs968.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/WhYgYkq9LX4Qr2EQGmLKQsDTIlVIYhUw=
X-SA-Exim-Connect-IP: 107.0.249.3
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4995]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Richard Guy Briggs <rgb@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH V4 1/8] namespaces: assign each namespace instance a serial number
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> Generate and assign a serial number per namespace instance since boot.
>
> Use a serial number per namespace (unique across one boot of one kernel)
> instead of the inode number (which is claimed to have had the right to change
> reserved and is not necessarily unique if there is more than one proc fs) to
> uniquely identify it per kernel boot.

This approach is just broken.

For this to work with migration (aka criu) you need to implement a
namespace of namespaces.  You haven't done this, and therefore
such an interface will break existing userspace.

Inside of audit I can understand not caring about these issues,
but you go foward and expose these serial numbers in proc,
and generally make this infrastructure available to others.

The deep issue with migration is that we move tasks from one machine
from another and on the destination machine we need to have all of the
same global identifiers for software to function properly.

My weasel words around the proc inode numbers is to preserve to allow us
room to be able to restore those ids if it every becomes relevant for
migration.

That is the proc inode numbers (technically) live in a pid namespace,
(aka a mount of proc).  So depending on the pid namespace you are in
or the mount of proc you look in the numbers could change.

Qualifications like that must exist to have a prayer of ever supporting
process migration in the crazy corner cases where people start caring
about inode numbers.

We currently don't and inode numbers for a namespace will never change
after a namespace is created.  So I think you really are ok using the
proc inode numbers.  I am happy declaring by fiat that the inode numbers
that audit uses are the numbers connected to the initial pid namespace.

At a fairly basic level anything that is used to identify namespaces for
any general purpose use needs to have most if not all of the same
properties of the proc inode numbers.  The most important of which is
being tied to some context/namespace so there is a ability if we ever
need it to migrate those numbers from one machine to another.

Eric

> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 8e78110..93cb380 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -41,6 +41,23 @@ struct nsproxy init_nsproxy = {
>  #endif
>  };
>  
> +/**
> + * ns_serial - compute a serial number for the namespace
> + *
> + * Compute a serial number for the namespace to uniquely identify it in
> + * audit records.
> + */
> +long long ns_serial(void)
> +{
> +	static atomic64_t serial = ATOMIC_INIT(4); /* reserved for IPC, UTS, user, PID */
> +	long long ret;
> +
> +	ret = atomic64_add_return(1, &serial);
> +	BUG_ON(!ret);
> +
> +	return ret;
> +}
> +
>  static inline struct nsproxy *create_nsproxy(void)
>  {
>  	struct nsproxy *nsproxy;
