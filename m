Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3KYXat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:30:49 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:58973 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KYXar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:30:47 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 25 Nov 2013 15:30:26 -0800
Message-ID: <CALCETrU9bLB2WziLCd9sopMoQVLhs7wXUj_=wOrV+Oh6T05PDQ@mail.gmail.com>
Subject: Race in check_stack_guard_page?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at the stack expansion code, and I'm not convinced it's
safe.  Aside from the obvious scariness of down_read(&mmap_sem) not
actually preventing vma changes, I think there's a real race.  Suppose
that you have a VM_GROWSDOWN vma above a VM_GROWSUP vma with a
single-page gap between them.  Suppose further that they have
different anon_vma roots.

If one ends up in expand_downwards and the other ends up in
expand_upwards at the same time, then each one can take
page_table_lock without re-checking that there's still room to expand.
 The result will be two vmas that share a page.

(This is presumably only possible on ia64.)

--Andy
