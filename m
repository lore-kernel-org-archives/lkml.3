Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab3EYSkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 14:40:13 -0400
Received: from smtp104.biz.mail.ne1.yahoo.com ([98.138.207.11]:47530 "HELO
	smtp104.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757598Ab3EYSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 14:40:08 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 May 2013 14:40:08 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tTFdxyUVM1nnUwyrkbTKkbZ8b3Du.3H89S75Zbkr8cVwlGu
 R9Ap92NsYbPPaMa1HzbLiN85hEziemC38DdrQCVrxWljbvmyVupAAqw71vbP
 ApGoT7BpSwNQrXNC2wfjwomrujQArZiXbR3sUntswn68ss7p.6LpnrQLANNR
 vcr_yMxIhJclDMcahkE2YuHt2PZZ5rxHK8EXCUsgUcEDS3Tp7UFrKsnksfhv
 jFxWrgSO9.cjXzvyntSBYjSEn5nV1QgZk8cJfKbXOzZpr5M1n6scq8ssTd4o
 eNtQPrnEJotZ9MXgXzpKq8m_KACOJv_E1IvSc6Y1DN_YQr0OZ1x1uRfRM.mD
 qXeJxMV9jSsqplEi7Pz9qYwaYptPpR0eCNJHCMmHvsRWt.2r0EsfpYNRdGC.
 3HT3tCF6dztGcb9MYeYd1s3zANKJjK575WlDrb8L79AlZ1S1H8ombct5EeCs
 cbJv2rTuMbKvPPoIfYBPTi1dTnhhFcJNyL77cNCrZFX8M7Z0L0Sje_YIEdjF
 3KYDJH.oEoG1EjmOwKkXzq8YQC9k3e38q
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp104.biz.mail.ne1.yahoo.com with SMTP; 25 May 2013 11:33:26 -0700 PDT
Message-ID: <51A1040A.80003@schaufler-ca.com>
Date: Sat, 25 May 2013 11:33:46 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Stupid VFS name lookup interface..
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com> <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com> <20130525165710.GC25399@ZenIV.linux.org.uk>
In-Reply-To: <20130525165710.GC25399@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2013 9:57 AM, Al Viro wrote:
> On Fri, May 24, 2013 at 08:21:08PM -0700, Linus Torvalds wrote:
>> On Tue, May 21, 2013 at 3:22 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> Untested patch attached. It compiles cleanly, looks sane, and most of
>>> it is just making the function prototypes look much nicer. I think it
>>> works.
>> Ok, here's another patch in the "let's make the VFS go faster series".
>> This one, sadly, is not a cleanup.
>>
>> The concept is simple: right now the inode->i_security pointer chasing
>> kills us on inode security checking with selinux. So let's move two of
>> the fields from the selinux security fields directly into the inode.
>> So instead of doing "inode->i_security->{sid,sclass}", we can just do
>> "inode->{i_sid,i_sclass}" directly.
>>
>> It's a very mechanical transform, so it should all be good, but the
>> reason I don't much like it is that I think other security models
>> might want to do something like this too, and right now it's
>> selinux-specific. I could imagine making it just an anonymous union of
>> size 64 bits or something, and just making one of the union entries be
>> an (anonymous) struct with those two fields. So it's not conceptually
>> selinux-specific, but right now it's pretty much a selinux hack.
>>
>> But it's a selinux-specific hack that really does matter. The
>> inode_has_perm() and selinux_inode_permission() functions show up
>> pretty high on kernel profiles that do a lot of filename lookup, and
>> it's pretty much all just that i_security pointer chasing and extra
>> cache miss.
>>
>> With this, inode->i_security is not very hot any more, and we could
>> move the i_security pointer elsewhere in the inode.
>>
>> Comments? I don't think this is *pretty* (and I do want to repeat that
>> it's not even tested yet), but I think it's worth it. We've been very
>> good at avoiding extra pointer dereferences in the path lookup, this
>> is one of the few remaining ones.
> Well...   The problem I see here is not even selinux per se - it's that
> "LSM stacking" insanity.  How would your anon union deal with that?  Which
> LSM gets to play with it when we have more than one of those turds around?

I don't know that the terms "insanity" and "turds" really do
the situation justice, but Al has a firm grasp on the nut of the issue.

The LSM stacking I've been working on (v14 due "real soon") would
render this change useless, as you'd have to have the multiple
instances of the special fields just as you'd need multiple blob
pointers. That would have to reintroduce the indirection you're
trying to be rid of. I have been working on the assumption that
the single blob pointer was all that could ever go into the inode.
If that's not true stacking could get considerably easier and could
have less performance impact.

Now I'll put on my Smack maintainer hat. Performance improvement is
always welcome, but I would rather see attention to performance of
the LSM architecture than SELinux specific hacks. The LSM blob
pointer scheme is there so that you (Linus) don't have to see the
dreadful things that we security people are doing. Is it time to
get past that level of disassociation? Or, and I really hate asking
this, have you fallen into the SELinux camp?


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

