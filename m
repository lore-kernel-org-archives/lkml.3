Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbbAFKAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:00:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbbAFKAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:00:51 -0500
Date: Tue, 6 Jan 2015 12:00:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH repost 09/16] metag/uaccess: fix sparse errors
Message-ID: <20150106100031.GA30325@redhat.com>
References: <1419499661-8566-1-git-send-email-mst@redhat.com>
 <1419499661-8566-10-git-send-email-mst@redhat.com>
 <54A6BC0E.50008@imgtec.com>
 <20150104105218.GA3208@redhat.com>
 <54AA5CEE.9050205@imgtec.com>
 <20150105130042.GA21602@redhat.com>
 <CAAG0J99RAe4L6n1zqmNwTCNUuFmU45OuGhy7EaZ6AkLQeTkogg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAG0J99RAe4L6n1zqmNwTCNUuFmU45OuGhy7EaZ6AkLQeTkogg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 02:47:19PM +0000, James Hogan wrote:
> On 5 January 2015 at 13:00, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Mon, Jan 05, 2015 at 09:44:14AM +0000, James Hogan wrote:
> >> On 04/01/15 10:52, Michael S. Tsirkin wrote:
> >> > On Fri, Jan 02, 2015 at 03:41:02PM +0000, James Hogan wrote:
> >> >> Hi,
> >> >>
> >> >> On 25/12/14 09:29, Michael S. Tsirkin wrote:
> >> >>> virtio wants to read bitwise types from userspace using get_user.  At the
> >> >>> moment this triggers sparse errors, since the value is passed through an
> >> >>> integer.
> >> >>>
> >> >>> Fix that up using __force.
> >> >>
> >> >> I still see these sparse warnings with metag even with your patch:
> >> >>
> >> >>   CHECK   drivers/vhost/vhost.c
> >> >> drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio32
> >> >> drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio32
> >> >> drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio32
> >> >> drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio32
> >> >> drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio32
> >> >> drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio32
> >> >> drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio32
> >> >> drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio32
> >> >> drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio16
> >> >> drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio16
> >> >>
> >> >> Which something like the following hunk fixes in a similar way to yours:
> >> >>
> >> >> diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/uaccess.h
> >> >> index 0748b0a97986..594497053748 100644
> >> >> --- a/arch/metag/include/asm/uaccess.h
> >> >> +++ b/arch/metag/include/asm/uaccess.h
> >> >> @@ -112,13 +112,17 @@ do {                                                            \
> >> >>    retval = 0;                                             \
> >> >>    switch (size) {                                         \
> >> >>    case 1:                                                         \
> >> >> -          retval = __put_user_asm_b((unsigned int)x, ptr); break; \
> >> >> +          retval = __put_user_asm_b((__force unsigned int)x, ptr); \
> >> >> +          break;                                                  \
> >> >>    case 2:                                                         \
> >> >> -          retval = __put_user_asm_w((unsigned int)x, ptr); break; \
> >> >> +          retval = __put_user_asm_w((__force unsigned int)x, ptr); \
> >> >> +          break;                                                  \
> >> >>    case 4:                                                         \
> >> >> -          retval = __put_user_asm_d((unsigned int)x, ptr); break; \
> >> >> +          retval = __put_user_asm_d((__force unsigned int)x, ptr); \
> >> >> +          break;                                                  \
> >> >>    case 8:                                                         \
> >> >> -          retval = __put_user_asm_l((unsigned long long)x, ptr); break; \
> >> >> +          retval = __put_user_asm_l((__force unsigned long long)x, ptr); \
> >> >> +          break;                                                  \
> >> >>    default:                                                        \
> >> >>            __put_user_bad();                                       \
> >> >>    }
> >> >>
> >> >> As far as I understand it, using __force on the value (as opposed to the
> >> >> pointer) is safe here, in the sense of not masking any genuine defects.
> >> >> Do you agree? Do you want to apply that hunk with your patch too?
> >> >
> >> > what about this code:
> >> >              u16 v = 0;
> >> >              int rc = get_user(v, (__force __le16 __user *)p);
> >> >
> >> > it should trigger a warning, does it?
> >>
> >> No, but it didn't previously either, and doesn't seem to with x86_64 either.
> >>
> >> I tried __be16 too, since I presume you're referring to a discrepancy
> >> between the native byte order of v (u16) and the foreign byte order of
> >> *p (__be16)?
> >>
> >> Cheers
> >> James
> >
> > Yes.
> > It certainly does for me.
> > Did you define __CHECK_ENDIAN__?
> >
> > Documentation/sparse.txt says:
> >
> > To perform endianness
> > checks, you may define __CHECK_ENDIAN__:
> >
> >         make C=2 CF="-D__CHECK_ENDIAN__"
> >
> > These checks are disabled by default as they generate a host of warnings.
> >
> >
> > Or just try with __virtio16 instead of __le16 - I think these are
> > enabled unconditionally.
> 
> right, thanks,
> 
> So before your patch:
> arch/metag/kernel/setup.c:153:18: warning: cast to restricted __le16
> arch/metag/kernel/setup.c:153:18: warning: incorrect type in
> assignment (different base types)
> arch/metag/kernel/setup.c:153:18:    expected unsigned short
> [unsigned] [usertype] v
> arch/metag/kernel/setup.c:153:18:    got restricted __le16 <noident>
> 
> after your patch:
> arch/metag/kernel/setup.c:153:18: warning: incorrect type in
> assignment (different base types)
> arch/metag/kernel/setup.c:153:18:    expected unsigned short
> [unsigned] [usertype] v
> arch/metag/kernel/setup.c:153:18:    got restricted __le16 <noident>
> 
> Changing to put_user, before my hunk above:
> arch/metag/kernel/setup.c:154:18: warning: cast to restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast from restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast to restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast from restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast to restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast from restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast to restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast from restricted __le16
> 
> after my hunk above:
> arch/metag/kernel/setup.c:154:18: warning: cast to restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast to restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast to restricted __le16
> arch/metag/kernel/setup.c:154:18: warning: cast to restricted __le16
> 
> It seems to still serve its purpose of warning (in one way or
> another), due to the implementation of put_user which does an explicit
> cast to the type of *ptr:
> 
> /*
>  * These are the main single-value transfer routines.  They automatically
>  * use the right size if we just have the right pointer type.
>  */
> #define put_user(x, ptr) \
>     __put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
> 
> Cheers
> James


Right. I would probably stick an explicit
	(x) = (ptr)
there.

Let me send a patch.


> >
> >
> >> >
> >> >
> >> >
> >> >> Note, this change also suppresses warnings for writing a pointer to
> >> >> userland due to the casts to unsigned int / unsigned long long, such as
> >> >> the following (each 4 times due to 4 cases above):
> >> >>
> >> >> kernel/signal.c:2740:25: warning: cast removes address space of expression
> >> >> kernel/signal.c:2747:24: warning: cast removes address space of expression
> >> >> kernel/signal.c:2760:24: warning: cast removes address space of expression
> >> >> kernel/signal.c:2761:24: warning: cast removes address space of expression
> >> >> kernel/signal.c:2775:24: warning: cast removes address space of expression
> >> >> kernel/signal.c:2779:24: warning: cast removes address space of expression
> >> >> kernel/signal.c:3202:25: warning: cast removes address space of expression
> >> >> kernel/signal.c:3225:17: warning: cast removes address space of expression
> >> >> kernel/futex.c:2769:16: warning: cast removes address space of expression
> >> >>
> >> >>>
> >> >>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >> >>> ---
> >> >>>  arch/metag/include/asm/uaccess.h | 4 ++--
> >> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >> >>>
> >> >>> diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/uaccess.h
> >> >>> index 0748b0a..c314b45 100644
> >> >>> --- a/arch/metag/include/asm/uaccess.h
> >> >>> +++ b/arch/metag/include/asm/uaccess.h
> >> >>> @@ -135,7 +135,7 @@ extern long __get_user_bad(void);
> >> >>>  ({                                                              \
> >> >>>   long __gu_err, __gu_val;                                \
> >> >>>   __get_user_size(__gu_val, (ptr), (size), __gu_err);     \
> >> >>> - (x) = (__typeof__(*(ptr)))__gu_val;                     \
> >> >>> + (x) = (__force __typeof__(*(ptr)))__gu_val;                     \
> >> >>
> >> >> Can you adjust the position of the \ to line up please
> >> >>
> >> >>>   __gu_err;                                               \
> >> >>>  })
> >> >>>
> >> >>> @@ -145,7 +145,7 @@ extern long __get_user_bad(void);
> >> >>>   const __typeof__(*(ptr)) __user *__gu_addr = (ptr);             \
> >> >>>   if (access_ok(VERIFY_READ, __gu_addr, size))                    \
> >> >>>           __get_user_size(__gu_val, __gu_addr, (size), __gu_err); \
> >> >>> - (x) = (__typeof__(*(ptr)))__gu_val;                             \
> >> >>> + (x) = (__force __typeof__(*(ptr)))__gu_val;                             \
> >> >>
> >> >> same here (this one causes a checkpatch error due to 80 column limit)
> >> >>
> >> >>>   __gu_err;                                                       \
> >> >>>  })
> >> >>>
> >> >>>
> >> >>
> >> >> With those changes,
> >> >> Acked-by: James Hogan <james.hogan@imgtec.com>
> >> >>
> >> >> Cheers
> >> >> James
> >> >>
> >> >
> >> >
> >>
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-metag" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
