Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3IFVsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:48:35 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:62970 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3IFVsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:48:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130906210546.GW13318@ZenIV.linux.org.uk>
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
	<1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
	<20130906210546.GW13318@ZenIV.linux.org.uk>
Date: Fri, 6 Sep 2013 14:48:32 -0700
X-Google-Sender-Auth: xageCQHZvvx-ieDRTF5Saso3nKY
Message-ID: <CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 2:05 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I can take that, but I'm really not convinced that we need writer lock
> there at all.  After all, if we really can get livelocks on that one,
> we would be getting them on d_lookup()...

d_lookup() does a _single_ path component. That's a *big* difference.

Sure, the hash chain that d_lookup() (well, __d_lookup()) ends up
walking is a bit more complicated than just following the dentry
parent pointer, but that's much harder to trigger than just creating a
really deep directory structure of single-letter nested directories,
and then doing a "getcwd()" that walks 1024+ parents, while another
thread is looping renaming things..

So I personally do feel a lot safer with the fallback to write locking here.

Especially since it's pretty simple, so there isn't really much downside.

             Linus
