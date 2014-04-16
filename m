Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaDPCOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:14:37 -0400
Received: from mano-163-54-shared.jabatus.fr ([109.234.163.54]:56446 "EHLO
	mano-163-54-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbaDPCOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:14:36 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 74C299D2CD72.A0B36
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534DE789.8000104@manux.info>
Date: Wed, 16 Apr 2014 04:14:33 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][6/11][MANUX] Kernel compatibility : directory hardlinks
References: <534D3765.4090403@manux.info> <20140415200629.GI4456@thunk.org> <534D9C44.1050505@manux.info> <20140415220119.GM4456@thunk.org> <534DBCF5.7070209@manux.info> <20140415233435.GS4456@thunk.org>
In-Reply-To: <20140415233435.GS4456@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 16/04/2014 01:34, Theodore Ts'o a écrit :
> On Wed, Apr 16, 2014 at 01:12:53AM +0200, Emmanuel Colbus wrote:
>> The solution is to use directory hardlinks. This way :
>>  - applications that want to communicate through /tmp can simply specify
>> that they have a dependancy on a package that provides a /tmp directory
>> for them; this way, the package manager will create a directory hardlink
>> named "/tmp" towards it in their chroot, and they will be able to do
>> their thing;
>> - as for the cleaning of /tmp, it is done by having all the /tmp
>> directories of all the applications hardlinked within the chroot of the
>> script tasked with cleaning them.
> 
> 
> That's what "bind mounts" in Linux are used for.
> 
> If you haven't studied how bind mounts and mount namespaces work in
> Linux, I'd strongly encourage that you take a look.  First of all,
> it's a much more powerful system, and secondly, that's what most
> container based systems are using.

Yes, I know about bind mounts; in fact, I've even used them as a Linux
sysadmin, and I thought about using them here. My issues with them
were :

- bind mounts are not persistant (they have to be re-instated at every
boot);
- I would have needed plenty of them (if a computer had 10.000
applications that each used a /tmp directory, then this would have
required 10.000 bind mounts),
- the initialization of the operating system would have been impossible.
Who would have created the bind mounts required for the proper operation
of init?
- As an annoying note, the creation of the bind mounts would have
required giving mount an access to, de facto, any directory in the system;
- More problematically, giving the mount process this access would have
required either to install mount, and all its dependancies, unchrooted
and completely outside of the whole architecture, or using something to
give mount this access from within its chroot. The annoying thing being
that this "something" needed would have been, uh, a bind mount.
- and finally, unless I'm mistaken, bind mount do not stack. That is, if
you have three groups of directories, a, b, and c, and you bind mount c
into b/c and b into a/b, you won't be able to access c as a/b/c. Thus,
the amount of bind mounts required to do this would have been clearly
astronomic. (1)


In addition, I had already determined that, to do what I wanted to do, I
would need a new kind of partition (for the rootlinks). So I decided I
could also go with directory hardlinks.

However, I *did* recognize that bind mount were very close to what I
needed. That's why I created my directory hardlinks in this way, as, in
fact, "static" bind mounts.


Regards,

Emmanuel



(1) By the way, don't worry, I didn't forget to put a security
preventing circular mounts, even with intermediary steps :-)
