Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3JXAVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 20:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3JXAVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 20:21:51 -0400
References: <87r4bcdok1.fsf@redhat.com> <CA+8MBb+0wruR-T8Rkk_WQ6Try4ct2ZCm8o=js4eO8s7cogcs+g@mail.gmail.com>
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Madper Xie <cxie@redhat.com>, Anton Vorontsov <anton@enomsg.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        =?utf-8?B?5oiQ6aqPIOiwog==?= <bbboson@gmail.com>
Subject: Re: [PATCH] pstore: avoid incorrectly mark entry as duplicate
In-reply-to: <CA+8MBb+0wruR-T8Rkk_WQ6Try4ct2ZCm8o=js4eO8s7cogcs+g@mail.gmail.com>
Date: Thu, 24 Oct 2013 08:21:40 +0800
Message-ID: <87k3h35xij.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tony.luck@gmail.com writes:

> On Wed, Oct 23, 2013 at 7:55 AM, Madper Xie <cxie@redhat.com> wrote:
>> The "duplicate" entries won't appear in pstorefs. And a complain will be
>> print -- pstore: failed to load 76 record(s) from 'efi'
>
> Maybe I don't quite get this - but it sounds like you have a whole lot
> of entries using up space in efivars that have similar names - differing
> just in the timestamp - that won't show up in the pstore filesystem - because
> we'd try to name them all the same thing.
>
Maybe I misunderstand you...

Sure pstore try to name them all the same thing, but it's another
issue. and it doesn't prevent entries showing up in pstore fs.

Consider the following case: (after efi-pstore support append mode, it
always like this case):

I choose four dumped efivars from my DELL XPS:
dump-type0-9-1-1380441690-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1380448560-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1380460890-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1382496073-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
         ^        ^       [              ^                   ]
         !        !                      !
       type    timestamp                GUID

When pstore load them from efivars, pstore incorrectly assuming that
efivars with the same TYPE, ID and GUID are duplicate.

list_for_each_entry(pos, &allpstore, list) {
	if (pos->type == type &&    /---
	    pos->id == id &&     <-| as I said, it only check type,id,psi
	    pos->psi == psi) {      \---
		rc = -EEXIST;    <- then set -EEXIST, and ignore *dup* entry
		break;
	}
}
You can see the code above, for those four entries, only one could be
showed in pstorefs, all others will get a -EEXIST. So I add a timestamp
check here, it's the only different part.

> How did all those things end up in efivars?
before the patch I can see 
dmesg-efi-1   dmesg-efi-11  dmesg-efi-3  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
dmesg-efi-10  dmesg-efi-2   dmesg-efi-4  dmesg-efi-6  dmesg-efi-8
after apply the patch:
[root@dhcp-13-41 vars]# ls /dev/pstore/
dmesg-efi-1  dmesg-efi-1   dmesg-efi-11  dmesg-efi-2  dmesg-efi-3  dmesg-efi-5  dmesg-efi-6  dmesg-efi-8
dmesg-efi-1  dmesg-efi-10  dmesg-efi-11  dmesg-efi-2  dmesg-efi-3  dmesg-efi-5  dmesg-efi-7  dmesg-efi-8
dmesg-efi-1  dmesg-efi-10  dmesg-efi-12  dmesg-efi-2  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-8
dmesg-efi-1  dmesg-efi-10  dmesg-efi-13  dmesg-efi-2  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
dmesg-efi-1  dmesg-efi-10  dmesg-efi-14  dmesg-efi-2  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
dmesg-efi-1  dmesg-efi-10  dmesg-efi-15  dmesg-efi-2  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
dmesg-efi-1  dmesg-efi-10  dmesg-efi-16  dmesg-efi-3  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
dmesg-efi-1  dmesg-efi-10  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-7  dmesg-efi-9
dmesg-efi-1  dmesg-efi-10  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-7  dmesg-efi-9
dmesg-efi-1  dmesg-efi-10  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-8  dmesg-efi-9
dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-8  dmesg-efi-9
dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-8  dmesg-efi-9
dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-5  dmesg-efi-6  dmesg-efi-8
dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-5  dmesg-efi-6  dmesg-efi-8
dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-5  dmesg-efi-6  dmesg-efi-8

>
> Wouldn't the right fix be to make pstore allow them all to appear (using the
> timestamp to differentiate names?) so that we could see them, log them,
> and then remove them from pstore (in turn freeing up efivars space - which
> people keep telling me is in short supply).
>
Yeah, many file have the same name, just like my case above. But it not
really block the file shows up and should be solved in another
patch. And I'm trying fix it.
> -Tony

-- 
Best,
Madper Xie.
