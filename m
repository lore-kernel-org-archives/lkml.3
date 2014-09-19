Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaISVVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:21:40 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48250 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaISVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:21:39 -0400
X-Originating-IP: 173.246.103.110
Date: Fri, 19 Sep 2014 14:21:28 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Richard Weinberger <richard@nod.at>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, sparse@chrisli.org,
        Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 5/7] signal: Silence nested-externs warnings
Message-ID: <20140919212128.GP26432@jtriplet-mobl1>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1411140580-20909-6-git-send-email-jeffrey.t.kirsher@intel.com>
 <541C4D57.9050507@nod.at>
 <1411141042.2513.3.camel@jtkirshe-mobl>
 <541C4E14.9010000@nod.at>
 <20140919172030.GA22293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919172030.GA22293@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 07:20:30PM +0200, Oleg Nesterov wrote:
> On 09/19, Richard Weinberger wrote:
> >
> > Am 19.09.2014 17:37, schrieb Jeff Kirsher:
> > >
> > > See patch 1 of the series.
> >
> > I was not CC'ed...
> 
> Me too, and thus I don't understand this patch.
> 
> But I have to admit it looks a bit ugly to me anyway.
> Can't we simply kill _NSIG_WORDS_is_unsupported_size ?

This looks quite preferable.  Can you post that with a commit message
and signoff?  Also, the indentation on the second of the three BUILD_BUG
calls has some spaces in it, which it shouldn't.  With those fixed:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index 750196f..679c9b4 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -67,7 +67,6 @@ static inline int sigismember(sigset_t *set, int _sig)
>  
>  static inline int sigisemptyset(sigset_t *set)
>  {
> -	extern void _NSIG_WORDS_is_unsupported_size(void);
>  	switch (_NSIG_WORDS) {
>  	case 4:
>  		return (set->sig[3] | set->sig[2] |
> @@ -77,7 +76,7 @@ static inline int sigisemptyset(sigset_t *set)
>  	case 1:
>  		return set->sig[0] == 0;
>  	default:
> -		_NSIG_WORDS_is_unsupported_size();
> +		BUILD_BUG();
>  		return 0;
>  	}
>  }
> @@ -90,7 +89,6 @@ static inline int sigisemptyset(sigset_t *set)
>  #define _SIG_SET_BINOP(name, op)					\
>  static inline void name(sigset_t *r, const sigset_t *a, const sigset_t *b) \
>  {									\
> -	extern void _NSIG_WORDS_is_unsupported_size(void);		\
>  	unsigned long a0, a1, a2, a3, b0, b1, b2, b3;			\
>  									\
>  	switch (_NSIG_WORDS) {						\
> @@ -107,7 +105,7 @@ static inline void name(sigset_t *r, const sigset_t *a, const sigset_t *b) \
>  		r->sig[0] = op(a0, b0);					\
>  		break;							\
>  	    default:							\
> -		_NSIG_WORDS_is_unsupported_size();			\
> +	    	BUILD_BUG();						\
>  	}								\
>  }
>  
> @@ -128,8 +126,6 @@ _SIG_SET_BINOP(sigandnsets, _sig_andn)
>  #define _SIG_SET_OP(name, op)						\
>  static inline void name(sigset_t *set)					\
>  {									\
> -	extern void _NSIG_WORDS_is_unsupported_size(void);		\
> -									\
>  	switch (_NSIG_WORDS) {						\
>  	    case 4: set->sig[3] = op(set->sig[3]);			\
>  		    set->sig[2] = op(set->sig[2]);			\
> @@ -137,7 +133,7 @@ static inline void name(sigset_t *set)					\
>  	    case 1: set->sig[0] = op(set->sig[0]);			\
>  		    break;						\
>  	    default:							\
> -		_NSIG_WORDS_is_unsupported_size();			\
> +		BUILD_BUG();						\
>  	}								\
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
