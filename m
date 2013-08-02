Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3HBRpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:45:19 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56136 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3HBRpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:45:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-nfs@vger.kernel.org, krbdev@mit.edu,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        linux-kernel@vger.kernel.org, simo@redhat.com
References: <87ob9hovop.fsf@xmission.com>
	<20130801173846.28023.19009.stgit@warthog.procyon.org.uk>
	<20130801173902.28023.68819.stgit@warthog.procyon.org.uk>
	<7289.1375463126@warthog.procyon.org.uk>
Date: Fri, 02 Aug 2013 10:44:46 -0700
In-Reply-To: <7289.1375463126@warthog.procyon.org.uk> (David Howells's message
	of "Fri, 02 Aug 2013 18:05:26 +0100")
Message-ID: <871u6coult.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX196lMgf6RPr8jMInB5fS8btF6TSrCpSEbo=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0114]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;David Howells <dhowells@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] KEYS: Add per-user_namespace registers for persistent per-UID kerberos caches
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> > The cache returned is a keyring named "_krb.<uid>" that the possessor can
>> > read, search, clear, invalidate, unlink from and add links to.  SELinux
>> > and co. get a say as to whether this call will succeed as the caller must
>> > have LINK permission on the cache keyring.
>> 
>> I think it would be more accurate to say you use the existing LSM
>> security hooks for security keys.
>
> Yes.
>
>> Calling out SELinux in particular just seems odd as there is absolutely
>> nothing SELinux specific in this patch.
>
> Sorry, I normally think of SELinux as that's what I usually deal with.  Yes,
> any and all LSMs.
>
>> > +		    !nsown_capable(CAP_SETUID))
>>
>> You you make this ns_capable(ns, CAP_SETUID);
>> 
>> nsown_capable is the right thing here but I am trying to remove the
>> function because it makes it too easy to not think about which
>> user namespace you are in.
>
> Okay.
>
>> > +	index_key.desc_len = sprintf(buf, "_krb.%u", __kuid_val(uid));
>> 
>> Please don't use the implementation detail __kuid_val.  Please use
>> from_kuid(&init_user_ns, uid) instead so it is explicitly documented
>> which user namespace you are using.
>
> Actually, I don't want that either.  I want the user-visible UID from the
> namespace.

Which is a definite reason to use from_kuid().  So you think about which
user namespace you want this to be seen in.

I guess if this is all in the user namespace from_kuid(ns, uid) is what
you are after.  I was thinking this was heading to the upcall which only
runs in the initial user namespace.  When passing things to the upcall
it makes sense to use values in the initial user namespace.

Eric
