Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaGUMSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:18:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbaGUMSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:18:49 -0400
Message-ID: <53CD0514.8040308@redhat.com>
Date: Mon, 21 Jul 2014 14:18:28 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: x86: Function for determining exception type
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il> <1405942650-22589-3-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1405942650-22589-3-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/07/2014 13:37, Nadav Amit ha scritto:
> +int kvm_exception_type(unsigned int nr)

The manual calls this the exception class.

Please open code this as an if like this

	int mask;

	/* This should never happen, right? */
	if (WARN_ON(nr > 31))
		return EXCPT_INTERRUPT;

	mask = 1 << nr;
	if (mask &
	    ((1 << DB_VECTOR) | (1 << BP_VECTOR) |
	     (1 << OF_VECTOR)))
		return EXCPT_TRAP;

	...

	/*
	 * If it is reserved, assume it is a fault and
	 * set RF.
	 */
	return EXCPT_FAULT;

> +	case VE_VECTOR:
> +		return EXCPT_FAULT;
> +	case DB_VECTOR:
> +		return EXCPT_FAULT_OR_TRAP;

It is only a fault for instruction fetch breakpoints.  You can modify
kvm_vcpu_check_breakpoint to set RF, add a comment here that fault
handling is done elsewhere, and return EXCPT_TRAP.

Paolo
