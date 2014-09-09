Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbaIIPtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:49:49 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53788 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbaIIPtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:49:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-man\@vger.kernel.org" <linux-man@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andy Lutomirski <luto@amacapital.net>, richard.weinberger@gmail.com,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <53F5310A.5080503@gmail.com>
	<87d2bhfxvc.fsf@x220.int.ebiederm.org> <540F07C7.9000300@gmail.com>
Date: Tue, 09 Sep 2014 11:49:34 -0400
In-Reply-To: <540F07C7.9000300@gmail.com> (Michael Kerrisk's message of "Tue,
	09 Sep 2014 06:59:35 -0700")
Message-ID: <87sik0oktt.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19kHezJTczWeiomO5DIpuF7y2LmDS32rKk=
X-SA-Exim-Connect-IP: 68.113.178.29
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: For review: user_namespace(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hi Eric,
>
> On 08/30/2014 02:53 PM, Eric W. Biederman wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> 
>>> Hello Eric et al.,
>>>
>>> For various reasons, my work on the namespaces man pages 
>>> fell off the table a while back. Nevertheless, the pages have
>>> been close to completion for a while now, and I recently restarted,
>>> in an effort to finish them. As you also noted to me f2f, there have
>>> been recently been some small namespace changes that you may affect
>>> the content of the pages. Therefore, I'll take the opportunity to
>>> send the namespace-related pages out for further (final?) review.
>>>
>>> So, here, I start with the user_namespaces(7) page, which is shown 
>>> in rendered form below, with source attached to this mail. I'll
>>> send various other pages in follow-on mails.
>>>
>>> Review comments/suggestions for improvements / bug fixes welcome.
>>>
>>> Cheers,
>>>
>>> Michael
>>>
>>> ==
>>>
>>> NAME
>>>        user_namespaces - overview of Linux user_namespaces
>>>
> [...]
>
>>>        When a new IPC, mount, network, PID, or UTS namespace is  created
>>>        via clone(2) or unshare(2), the kernel records the user namespace
>>>        of the creating process against the new namespace.  (This associ‐
>>>        ation  can't  be  changed.)   When a process in the new namespace
>>>        subsequently  performs  privileged  operations  that  operate  on
>>>        global resources isolated by the namespace, the permission checks
>>>        are performed according to the process's capabilities in the user
>>>        namespace that the kernel associated with the new namespace.
>> 
>> Restrictions on mount namespaces.
>> 
>> - A mount namespace has a owner user namespace.  A mount namespace whose
>>   owner user namespace is different than the owerner user namespace of
>>   it's parent mount namespace is considered a less privileged mount
>>   namespace.
>> 
>> - When creating a less privileged mount namespace shared mounts are
>>   reduced to slave mounts.  This ensures that mappings performed in less
>>   privileged mount namespaces will not propogate to more privielged
>>   mount namespaces.
>> 
>> - Mounts that come as a single unit from more privileged mount are
>>   locked together and may not be separated in a less privielged mount
>>   namespace.
>
> Could you clarify what you mean by "Mounts that come as a single
> unit"?

unshare(CLONE_NEWNS) brings across all of the mounts from the original
mount namespace as a single unit.

recursive mounts that propogate between mount namespaces propogate as a
single unit.

The importance of this is allow the global root to mount over things
and not have to worry that someone from a user namespace root can
peek underneath.

>> - The mount flags readonly, nodev, nosuid, noexec, and the mount atime
>>   settings when propogated from a more privielged to a less privileged
>>   mount namespace become locked, and may not be changed in the less
>>   privielged mount namespace.
>> 
>> - (As of 3.18-rc1 (in todays Al Viros vfs.git#for-next tree)) A file or
>>   directory that is a mountpoint in one namespace that is not a mount
>>   point in another namespace, may be renamed, unlinked, or rmdired in
>>   the mount namespace in which it is not a mount namespace if the
>>   ordinary permission checks pass.
>> 
>>   Previously attemping to rmdir, unlink or rename a file or directory
>>   that was a mount point in another mount namespace would result in
>>   -EBUSY.  This behavior had technical problems of enforcement (nfs)
>>   and resulted in a nice denial of servial attack against more
>>   privileged users.  (Aka preventing individual files from being updated
>>   by bind mounting on top of them).
>
> I have reworked the text above a little so that now we have the following.
> Aside from question above, does it look okay?
>
>    Restrictions on mount namespaces
>        Note the following points with respect to mount namespaces:
>
>        *  A  mount  namespace  has  na  owner user namespace.  A mount
                                     ^s/na/an/
>           namespace whose owner user namespace is different  from  the
>           owner  user  namespace of its parent mount namespace is con‐
>           sidered a less privileged mount namespace.
>
>        *  When creating a  less  privileged  mount  namespace,  shared
>           mounts  are reduced to slave mounts.  This ensures that map‐
>           pings performed in less privileged mount namespaces will not
>           propagate to more privileged mount namespaces.
>
>        *  Mounts that come as a single unit from more privileged mount
            ^ namespaces
>           are locked together and may not be separated in a less priv‐
>           ileged mount namespace.
>
>        *  The  mount(2) flags MS_RDONLY, MS_NOSUID, MS_NOEXEC, and the
>           "atime" flags (MS_NOATIME, MS_NODIRATIME, MS_RELATIME)  set‐
>           tings  become  locked when propagated from a more privileged
>           to a less privileged mount namespace, and may not be changed
>           in the less privileged mount namespace.
>
>        *  A  file  or directory that is a mount point in one namespace
>           that is not a mount  point  in  another  namespace,  may  be
>           renamed, unlinked, or removed (rmdir(2)) in the mount names‐
>           pace in which it is not a mount point (subject to the  usual
>           permission checks).
>
>           Previously,  attempting  to unlink, rename, or remove a file
>           or directory that was a mount point in another mount  names‐
>           pace  would  result  in  the error EBUSY.  That behavior had
>           technical problems of enforcement (e.g., for NFS)  and  per‐
>           mitted  denial-of-service  attacks  against  more privileged
>           users.   (i.e.,  preventing  individual  files  from   being
>           updated by bind mounting on top of them).

Subject to tiny typo corrections that looks fine.

Eric
