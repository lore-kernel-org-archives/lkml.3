Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934700Ab3E1Q0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:26:33 -0400
Received: from smtp104.biz.mail.gq1.yahoo.com ([98.137.12.179]:33257 "HELO
	smtp104.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934576Ab3E1Q0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:26:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iE1Qq7AVM1lMeCTtNKnJuV9Yl37WvDyGyWjHgu6audn7nEL
 rSDCG8It4zSkBqll7cg9BmXsBCC_JTtp6DchpPcNxdePw.RYr3ezoV6583Eq
 8fBGW6Ghn5vwrGSSK3BuDav0ImxZ6aNNH8xurodJL5EJEuONMqUnWCK9cn3k
 VemCxdrpS0.47mErWC7bZTxgeQbwD_aXy60cpQl.LY2nw87GPHrRJov8KSAF
 ilDD2NffshrRv0TaeHARRpDEaE_VMCgNVGt4NArM_mf8MTwnXKEl5gpZj9lB
 kFcubptn5F8mPnv7T3hBGcekxfIbSpxqVDJZfGGPGWyrOnJMW_A_u94OSC_X
 kTeLR_xSicRe9OiwY.91t5_NskwE5jvpmmle5nh7rpWDdcmVA5.xaP5hu_iA
 Nwzwi9bob.HXfb_ok7_nAX9mqXSbm26TUiOy1L3Ka1CE_ToPFa7U2XK8Cqzx
 3PwCsm89Cx4.aIapK9r3PgAQwOolkqDJyIpi0UkuAyhFfuQImzo02KJp.4BE
 25ZfBomg_5jF9UFLw_jg-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp104.biz.mail.gq1.yahoo.com with SMTP; 28 May 2013 09:26:30 -0700 PDT
Message-ID: <51A4DAB6.60806@schaufler-ca.com>
Date: Tue, 28 May 2013 09:26:30 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Stupid VFS name lookup interface..
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com> <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com> <20130525165710.GC25399@ZenIV.linux.org.uk> <51A1040A.80003@schaufler-ca.com> <20130526120251.GA32729@thunk.org> <51A25305.90101@schaufler-ca.com> <20130526191124.GB32729@thunk.org> <CA+55aFxueg-wBRdUw=S=TOAnHy3BorGYMzffiDkjU90BCTzcig@mail.gmail.com>
In-Reply-To: <CA+55aFxueg-wBRdUw=S=TOAnHy3BorGYMzffiDkjU90BCTzcig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2013 12:32 PM, Linus Torvalds wrote:
> On Sun, May 26, 2013 at 12:11 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> And if we can't rip out that fundamental assumption, it's not obvious
>> to me it will be possible to simplify the core LSM architecture.
> One thing that may be sufficient is to maintain a complex model as a
> *possible* case, but make sure that we handle the simple cases well.
>
> For example, a "security cache" *might* be as simple as a single bit
> saying "this inode has no special file permissions outside the normal
> UNIX ones".
>
> For example, the biggest win in the whole POSIX ACL cache was not
> actually caching POSIX ACL's at all - even though it does that - but
> caching the fact that a particular file did *not* have any POSIX ACL's
> associated with it. So the POSIX AXL cache was very much designed to
> have separate states for "I don't have a cache entry" and "I have an
> empty cache entry". And 99% of the time, that negative cache is
> sufficient.

POSIX ACLs work well in this scheme for two reasons. First, they are
optional and only show up on files when someone wants to put one there.
Second, no one seems inclined to use them. Because the existence of an
ACL is rare it makes *lots* of sense to shortcut if there is no ACL.

SELinux contexts and Smack labels are different from ACLs in that
the usual case will be that the label exists and a file without the
extended attribute will be quite rare. Because every file is expected
to have a context/label no check that is as simple or convenient as
what you have with ACLs is available.

> Similarly, for at least the filesystem security case, if we had a "the
> owner of this file can do all the normal operations on it" bit, that
> would generally take care of 99% of all home directory operations. If,
> in addition to that, there's some way to mark other "normal"
> directories as having only normal UNIX security semantics (ie /home
> and /usr), that would take care of most of the rest.

This is pretty close to the Smack "Basic Rule", which says that a process
with the same label as an object can do what it will with it. You only
go looking at the Smack rules if this check fails.

SELinux (Eric, James, correct me where I mislead) may need to do some
calculation based on the process context, containing directory, component
name and (perhaps) other factors before it's possible to determine exactly
what contexts are being compared. It may very well be possible to do some
amount of advanced computation on this, but how that might work is beyond
me.

It might be possible to implement labeling on a filesystem basis, and
achieve performance tricks based on that. Both SELinux and Smack are
capable of providing a single context/label for a filesystem, although
Smack currently always uses extended attributes when they are available.
This would be of limited value in most of the configurations I have seen.


> Having to call into the security layer when you cross some special
> boundary is fine. It's doing it for every single path component, and
> every single 'stat' of a regular file - *THAT* is what kills us.

Hmm. If we associated the access checks with the object rather than the
task we might be able to do something here. That's the VFS caching that
you've been referring to, I expect. On a system with a small number of
contexts/labels I'd expect this to help.

> So complexity could be ok. As long as the common case isn't complex,
> and as long as there's a simple way to check that. We don't
> necessarily need to simplify things in the general case.

Keeping the common case common is the problem with mandatory access
control systems. Once the granularity gremlins get control of a
distribution no one access case is ever going to be the common case.

>
>              Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

