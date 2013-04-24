Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3DXVPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:15:41 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:51435 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3DXVPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:15:39 -0400
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v13 0/9] LSM: Multiple concurrent LSMs
Date: Wed, 24 Apr 2013 17:15:36 -0400
Message-ID: <3235150.vl4U7U54yV@sifl>
User-Agent: KMail/4.10.2 (Linux/3.8.5-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51783EFC.8050607@schaufler-ca.com>
References: <5176ABB7.5080300@schaufler-ca.com> <3554062.6nBMExN24s@sifl> <51783EFC.8050607@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 24, 2013 01:22:20 PM Casey Schaufler wrote:
> On 4/24/2013 11:57 AM, Paul Moore wrote:
> > I know we had a good discussion about this a while back and I just wanted
> > to hear from you about this current patchset; how does the labeled
> > networking LSM assignment work?  Is it first-come-first-served based on
> > the 'security=' setting?
> 
> It's explicitly set in security/Kconfig. The problem with
> first-come-first-serve is that the LSMs don't actually register
> in the order specified, either at build time or boot time.
> Further, until the init phase is complete, you don't know which
> LSMs are actually going to register. That, and I promised Tetsuo
> I wouldn't go out of my way to prevent late module loading in
> the future.
> 
> I could do order checking on module registration and take
> the networking component away from an LSM that registered
> earlier, but with a larger order number I suppose.

Hmmm.  How difficult would it be to enforce the order during LSM registration?  
As discussed previously, I'm not a big fan of assigning the network controls 
at compile time when the LSMs can be toggled at boot time.

The real solution is to just get the netdev folks to accept a security blob in 
the sk_buff so we can fix this (and many other problems) once and for all.  I 
still haven't given up on this effort but I think it would be silly to hold up 
the stacking effort for the sk_buff security blob.

> The default configuration gives xfrm and secmark to SELinux
> and NetLabel to Smack. If Smack is not included NetLabel goes
> to SELinux. When LSMs using any of these facilities are added
> in the future we'll have to negotiate the defaults.

The defaults are always going to be wrong for someone.

> An interesting aside that may be relevant is that the error
> condition behavior makes it advisable to have the LSM you care
> about most go last. If the networking components were strictly
> FCFS you might have to chose an ordering you might not want for
> other reasons.

Well, maybe not ... I think.  If we take a FCFS approach to the network 
controls then only one LSM is really ever going to throw an error on the 
network hooks, yes?

> It would be possible to have a boot time specification for
> the networking components if you think it's important. I do
> worry about making it excessively complicated. I'd be much more
> concerned if more LSMs used the networking components.

I think the "excessively complicated" boat has already sailed :)

I'm still in favor of assigning the network hooks to the LSM at boot based on 
the "security=" configuration.

-- 
paul moore
www.paul-moore.com

