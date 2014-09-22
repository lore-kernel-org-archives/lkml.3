Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaIVR0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:26:21 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:53865 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaIVR0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:26:19 -0400
X-Originating-IP: 75.92.167.159
Date: Mon, 22 Sep 2014 10:26:05 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, sparse@chrisli.org,
        Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 1/1] signal: use BUILD_BUG() instead of
 _NSIG_WORDS_is_unsupported_size()
Message-ID: <20140922172605.GF25352@thin>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1411140580-20909-6-git-send-email-jeffrey.t.kirsher@intel.com>
 <541C4D57.9050507@nod.at>
 <1411141042.2513.3.camel@jtkirshe-mobl>
 <541C4E14.9010000@nod.at>
 <20140919172030.GA22293@redhat.com>
 <20140919212128.GP26432@jtriplet-mobl1>
 <20140921164243.GA16744@redhat.com>
 <20140921164306.GB16744@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140921164306.GB16744@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 06:43:06PM +0200, Oleg Nesterov wrote:
> Kill _NSIG_WORDS_is_unsupported_size(), use BUILD_BUG() instead.
> This simplifies the code, avoids the nested-externs warnings, and
> this way we do not defer the problem to linker.
> 
> Also, fix the indentation in _SIG_SET_BINOP() and _SIG_SET_OP().
> 
> Note: this patch assumes that the code like "if (0) BUILD_BUG();"
> is valid. If not (say __compiletime_error() is not defined and thus
> __compiletime_error_fallback() uses a negative array) we should fix
> BUILD_BUG() and/or BUILD_BUG_ON_MSG(). This code should be fine by
> definition, this is the documented purpose of BUILD_BUG().
> 
> Reported-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks for posting this.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/signal.h |   28 ++++++++++++----------------
>  1 files changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index 750196f..14acfd5 100644
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
> @@ -90,24 +89,23 @@ static inline int sigisemptyset(sigset_t *set)
>  #define _SIG_SET_BINOP(name, op)					\
>  static inline void name(sigset_t *r, const sigset_t *a, const sigset_t *b) \
>  {									\
> -	extern void _NSIG_WORDS_is_unsupported_size(void);		\
>  	unsigned long a0, a1, a2, a3, b0, b1, b2, b3;			\
>  									\
>  	switch (_NSIG_WORDS) {						\
> -	    case 4:							\
> +	case 4:								\
>  		a3 = a->sig[3]; a2 = a->sig[2];				\
>  		b3 = b->sig[3]; b2 = b->sig[2];				\
>  		r->sig[3] = op(a3, b3);					\
>  		r->sig[2] = op(a2, b2);					\
> -	    case 2:							\
> +	case 2:								\
>  		a1 = a->sig[1]; b1 = b->sig[1];				\
>  		r->sig[1] = op(a1, b1);					\
> -	    case 1:							\
> +	case 1:								\
>  		a0 = a->sig[0]; b0 = b->sig[0];				\
>  		r->sig[0] = op(a0, b0);					\
>  		break;							\
> -	    default:							\
> -		_NSIG_WORDS_is_unsupported_size();			\
> +	default:							\
> +		BUILD_BUG();						\
>  	}								\
>  }
>  
> @@ -128,16 +126,14 @@ _SIG_SET_BINOP(sigandnsets, _sig_andn)
>  #define _SIG_SET_OP(name, op)						\
>  static inline void name(sigset_t *set)					\
>  {									\
> -	extern void _NSIG_WORDS_is_unsupported_size(void);		\
> -									\
>  	switch (_NSIG_WORDS) {						\
> -	    case 4: set->sig[3] = op(set->sig[3]);			\
> -		    set->sig[2] = op(set->sig[2]);			\
> -	    case 2: set->sig[1] = op(set->sig[1]);			\
> -	    case 1: set->sig[0] = op(set->sig[0]);			\
> +	case 4:	set->sig[3] = op(set->sig[3]);				\
> +		set->sig[2] = op(set->sig[2]);				\
> +	case 2:	set->sig[1] = op(set->sig[1]);				\
> +	case 1:	set->sig[0] = op(set->sig[0]);				\
>  		    break;						\
> -	    default:							\
> -		_NSIG_WORDS_is_unsupported_size();			\
> +	default:							\
> +		BUILD_BUG();						\
>  	}								\
>  }
>  
> -- 
> 1.5.5.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
