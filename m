Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3AYAq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:46:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3AYAqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:46:19 -0500
Date: Thu, 24 Jan 2013 16:46:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v2] userns: improve uid/gid map collision detection
Message-Id: <20130124164612.af6de6f3.akpm@linux-foundation.org>
In-Reply-To: <20130124152859.GP17632@redhat.com>
References: <20130123160221.GG17632@redhat.com>
	<20130124044438.GA13354@mail.hallyn.com>
	<20130124152859.GP17632@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013 10:28:59 -0500
Aristeu Rozanski <aris@redhat.com> wrote:

> userns: improve uid/gid map collision detection
> 
> Initial implementation of the uid/gid maps (/proc/<pid>/{u,g}id_map) will
> enforce that the UID and GID maps be written in strict order as a simple
> way to check for range collision:
> 	local id	mapped to	count/range
> 	0		1000		50
> 	(ids 0-50 get mapped to 1000-1050)
> 	100		2120		10
> 	500		5000		200
> so for each new entry, local id must be bigger than last local id (plus
> count) and the ids it maps to also needs to be bigger than the last
> entry (plus count).
> 
> This makes impossible to have a use case like this:
> 	local id	mapped to	count/range
> 	0		1000		1
> 	48		500		20
> 
> because while 48+20 > 0+1, 500+20 < 1000+1.
> 
> This patch implements a more elaborate collision detection allowing any
> order to be used.
> 
> v2: improved the patch description as requested by Andrew

Thanks.

> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -521,6 +521,28 @@ struct seq_operations proc_projid_seq_operations = {
>  
>  static DEFINE_MUTEX(id_map_mutex);
>  
> +#define in_range(b,first,len) ((b)>=(first)&&(b)<(first)+(len))

eek, a macro!  Macros are always bad.

This one is bad because

a) it's a macro

b) it evaluates its args multiple times and hence will cause nasty
   bugs if called with expressions-with-side-effects.

c) it evaluates its args multiple times and if called with
   non-trivial expressions the compiler might not be able to CSE those
   expressions, leading to code bloat.

Add lo, this patch:

--- a/kernel/user_namespace.c~userns-improve-uid-gid-map-collision-detection-fix
+++ a/kernel/user_namespace.c
@@ -521,7 +521,11 @@ struct seq_operations proc_projid_seq_op
 
 static DEFINE_MUTEX(id_map_mutex);
 
-#define in_range(b,first,len) ((b)>=(first)&&(b)<(first)+(len))
+static bool in_range(u32 b, u32 first, u32 len)
+{
+	return b >= first && b < first + len;
+}
+
 static inline int extent_collision(struct uid_gid_map *new_map,
 				   struct uid_gid_extent *extent)
 {

reduces the user_namespace.o text from 4822 bytes to 4727 with
gcc-4.4.4.  This is a remarkably large difference.


btw, what the heck is up with CONFIG_UIDGID_CONVERTED?  That thing
prevents userns from being compiled in an allmodconfig build, which is
rather undesirable.  Isn't there a better, more user-friendly way of
doing this?

