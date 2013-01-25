Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3AYCBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:01:01 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33477 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3AYCAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:00:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <20130123160221.GG17632@redhat.com>
	<20130124044438.GA13354@mail.hallyn.com>
	<20130124152859.GP17632@redhat.com>
	<20130124164612.af6de6f3.akpm@linux-foundation.org>
Date: Thu, 24 Jan 2013 18:00:47 -0800
In-Reply-To: <20130124164612.af6de6f3.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 24 Jan 2013 16:46:12 -0800")
Message-ID: <87d2wuuils.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX188QvT4F7YyqRQ+fv8UJX9EEjN4fMuZ/P8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1773]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] userns: improve uid/gid map collision detection
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I will look at this patch in a bit.  I already have a similar patch
in my queue, although I don't know if I have pushed that out yet.


Andrew Morton <akpm@linux-foundation.org> writes:

> btw, what the heck is up with CONFIG_UIDGID_CONVERTED?  That thing
> prevents userns from being compiled in an allmodconfig build, which is
> rather undesirable.  Isn't there a better, more user-friendly way of
> doing this?

CONFIG_UIDGID_CONVERTED is what keeps the allmodconfig building with user
namespaces enabled.

The practical issue is that the uid_t, gid_t converstion to kuid_t and
kgid_t is not quite done.  And it takes a lot of pain staking review in
some cases to get it done.

In places where the conversion is not complete the code fails to compile
preventing the introduction of security holes.

If you look in init/Kconfig at the definition of CONFIG_UIDGID_CONVERTED
you see the list of filesystems that still need changes.

I have the basic version of those changes queued up, and I believe those
changes are correct.  However I need to break them into smaller patches
to make the changes obviously correct.  One of the things I have
discovered along the way of making these conversions is that I need to
push kuid_t and kgid_t as deep and as thoroughly into the code as I can
or I will fail to place conversions where they need to be.

The amount of work required on those final pieces appears to be
proportional to the size of the filesystem rather than proportional to
the size of the changes to those filesystems.  Because there is so much
code that must be reviewed and understood.

I am hoping I can get the conversions done and CONFIG_UIDGID_CONVERTED
can be killed for 3.9 but we will see.

Eric


