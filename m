Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3G3Btr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:49:47 -0400
Received: from smtp106.biz.mail.ne1.yahoo.com ([98.138.207.13]:48706 "HELO
	smtp106.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752062Ab3G3Btp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:49:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SnYW8okVM1mpufawXPQ.qJM8SVSxNvnXcxM_whzdUUOi7CR
 oxuBhUs6p87O_hVCFtpa9wYaNSJV0CiPKhYj7doLgeMJZfGiMFaKMTDUUJmw
 4D1awnliJtJXze8VSFOG5zU8ADL4MkrNVAju5AGx1W4yf4YpNh0yl3ipOaOz
 f3aSB6.EAGmEVAuGfxSpYUIexY80RD9e_YasUlXMglzFpj.LZdFJCyTec2gi
 I_S4HI68ZJnPs9HHAfd9qbloRI0QBDA5qKgYi0btrxZfqG3lFtkg1ibRdt3b
 knTTC0lAVH_15p7S_15N7L1FU70WKtsgLTdW778xTRVtoFaVY70txR.RSJCF
 2A9GAjnuAfRmeEBm.YtqU_61U42bUEfw.8yWtQ1iM853cC.XdrlbWh1lUiAe
 KL_X3zYJNGx6TiTdwj.d1AgZ0Jszj4ow4BQDzjez1TYYF0prY8sDpabqVFtQ
 f88D14fa4Z6L1r1Jsv3GSsW.xEpYC0nvPCT.H0TnEeE9YZWVyB_2TNODxmgB
 smuabXABNrxpX
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp106.biz.mail.ne1.yahoo.com with SMTP; 29 Jul 2013 18:49:44 -0700 PDT
Message-ID: <51F71BB5.2050101@schaufler-ca.com>
Date: Mon, 29 Jul 2013 18:49:41 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v14 1/6] LSM: Security blob abstraction
References: <51F16CFB.6040603@schaufler-ca.com> <51F16F21.3020305@schaufler-ca.com> <CAGXu5jJUiwjtEuCUB89NG9EQpxNytaaPT9PdPyHN_qUhwa+YUw@mail.gmail.com>
In-Reply-To: <CAGXu5jJUiwjtEuCUB89NG9EQpxNytaaPT9PdPyHN_qUhwa+YUw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/2013 2:15 PM, Kees Cook wrote:
> On Thu, Jul 25, 2013 at 11:32 AM, Casey Schaufler
> <casey@schaufler-ca.com> wrote:
>> Subject: [PATCH v14 1/6] LSM: Security blob abstraction
>>
>> Create an abstracted interface for security blobs.
>> Instead of directly accessing security blob pointers
>> Use lsm_get and lsm_set functions that hide the actual
>> mechanism used to maintain the security blobs. This
>> affects most uses of inode->i_security, file->f_security,
>> cred->security and similar fields in keys, sockets,
>> superblocks, ipc and keys.
>>
>> The use of a single 32 bit integer to refer to a security blob
>> does not scale to the case where there may be more than one
>> relevant security blob. Where it is possible to do so the use
>> of secids (u32) has been replaced with a struct secids, which
>> provides for multiple u32 values. There are components where
>> u32 secids remain at the request of the maintainer of that
>> component.
> If I boot with "security=apparmor", lsm_set_blob ends up with a NULL
> "bp" and Oopses the kernel. Still happens with
> "security=yama,apparmor". As soon as I add smack anywhere in the list,
> everything is fine. It seems like the AppArmor init needs to be
> changed to:
>
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 78b271a..512f430 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -875,9 +875,9 @@ static int __init set_init_cxt(void)
>                 return -ENOMEM;
>
>         cxt->profile = aa_get_profile(root_ns->unconfined);
> -       lsm_set_cred(cred, cxt, &apparmor_ops);
> -
> -       return 0;
> +       printk(KERN_INFO "AA: cred:%p cxt:%p &apparmor_ops:%p\n",
> +               cred, cxt, &apparmor_ops);
> +       return lsm_set_init_cred(cred, cxt, &apparmor_ops);

I've incorporated this fix (without the printk) and she looks good.

>  }
>
>  static int __init apparmor_init(void)
>
> Or maybe it still needs lsm_set_cred, but an earlier
> lsm_set_init_cred? It's not clear to me yet.
>
> -Kees
>

