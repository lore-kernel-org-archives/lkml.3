Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab3CNBs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 21:48:28 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:52196 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab3CNBs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 21:48:27 -0400
Message-ID: <51412C67.30908@mit.edu>
Date: Wed, 13 Mar 2013 18:48:23 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Kees Cook <keescook@chromium.org>, containers@lists.linux-foundation.org,
        Sebastian Krahmer <krahmer@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: CLONE_NEWUSER|CLONE_FS root exploit
References: <20130313175729.GH12501@outflux.net> <87r4jjkv18.fsf@xmission.com>
In-Reply-To: <87r4jjkv18.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 11:35 AM, Eric W. Biederman wrote:
> Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> writes:
> 
>> Hi,
>>
>> It seem like we should block (at least) this combination. On 3.9, this
>> exploit works once uidmapping is added.
>>
>> http://www.openwall.com/lists/oss-security/2013/03/13/10
> 
> Yes.  That is a bad combination.  It let's chroot confuse privileged
> processes.
> 
> Now to figure out if this is easier to squash by adding a user_namespace
> to fs_struct or by just forbidding this combination.

It's worth making sure that setns(2) doesn't have similar issues.

Looking through other shared-but-not-a-namespace things, there are:

fs_struct: Buggy as noted.

files_struct: Probably harmless -- SCM_RIGHTS can emulate it

signal_struct: This interacts with the tty code.  Is it okay?

sighand_struct: Looks safe.  Famous last words.

FWIW, I've been alarmed in the past that struct path (e.g. the root
directory) implies an mnt_namespace (hidden in struct mount), and it's
entirely possible for the root directory's mnt_namespace not to match
nsproxy->mnt_namespace.  I'm not sure what the implications are, but
this doesn't seem healthy.

--Andy
